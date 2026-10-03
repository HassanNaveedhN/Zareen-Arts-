<?php

header("Content-Type: application/json");

require_once __DIR__ . "/db.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    echo json_encode([
        "success" => false,
        "message" => "Invalid request method."
    ]);

    exit;
}

$data = json_decode(
    file_get_contents("php://input"),
    true
);

if (!is_array($data)) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid order data."
    ]);

    exit;
}


/*
|--------------------------------------------------------------------------
| Customer information
|--------------------------------------------------------------------------
*/

$customer_name =
    trim($data["customer_name"] ?? "");

$phone =
    trim($data["phone"] ?? "");

$email =
    trim($data["email"] ?? "");

$city =
    trim($data["city"] ?? "");

$address =
    trim($data["address"] ?? "");

$delivery_date =
    trim($data["delivery_date"] ?? "");


/*
|--------------------------------------------------------------------------
| Payment information
|--------------------------------------------------------------------------
*/

$payment_method =
    trim($data["payment_method"] ?? "");

$payment_reference =
    trim($data["payment_reference"] ?? "");


/*
|--------------------------------------------------------------------------
| Other information
|--------------------------------------------------------------------------
*/

$custom_notes =
    trim($data["custom_notes"] ?? "");


/*
|--------------------------------------------------------------------------
| Validation
|--------------------------------------------------------------------------
*/

if (
    empty($customer_name) ||
    empty($phone) ||
    empty($city) ||
    empty($address) ||
    empty($delivery_date) ||
    empty($payment_method)
) {
    echo json_encode([
        "success" => false,
        "message" =>
            "Please fill in all required fields."
    ]);

    exit;
}


/*
|--------------------------------------------------------------------------
| Get cart
|--------------------------------------------------------------------------
*/

$items =
    $data["items"] ?? [];

if (
    empty($items) ||
    !is_array($items)
) {
    echo json_encode([
        "success" => false,
        "message" => "Your cart is empty."
    ]);

    exit;
}


/*
|--------------------------------------------------------------------------
| Prepare order items
|--------------------------------------------------------------------------
*/

$total = 0;

$order_items = [];


/*
|--------------------------------------------------------------------------
| Process every cart item
|--------------------------------------------------------------------------
*/

foreach ($items as $item) {

    $product_id =
        intval($item["id"] ?? 0);

    $quantity =
        intval($item["qty"] ?? 0);

    $custom =
        $item["custom"] ?? [];

    if (
        $product_id <= 0 ||
        $quantity <= 0
    ) {
        continue;
    }


    /*
    |--------------------------------------------------------------------------
    | Get product
    |--------------------------------------------------------------------------
    */

    $stmt = $conn->prepare("
        SELECT
            id,
            name,
            category,
            price,
            size_prices
        FROM products
        WHERE id = ?
        AND active = 1
        LIMIT 1
    ");

    if (!$stmt) {
        echo json_encode([
            "success" => false,
            "message" =>
                "Database error: " .
                $conn->error
        ]);

        exit;
    }

    $stmt->bind_param(
        "i",
        $product_id
    );

    $stmt->execute();

    $result =
        $stmt->get_result();

    $product =
        $result->fetch_assoc();

    $stmt->close();


    if (!$product) {
        echo json_encode([
            "success" => false,
            "message" =>
                "One of the selected products was not found."
        ]);

        exit;
    }


    /*
    |--------------------------------------------------------------------------
    | Base price
    |--------------------------------------------------------------------------
    */

    $price =
        floatval($product["price"]);


    /*
    |--------------------------------------------------------------------------
    | Cake size price
    |--------------------------------------------------------------------------
    */

    if (
        $product["category"] === "cakes" &&
        !empty($custom["size"])
    ) {

        $size_prices = [];

        if (!empty($product["size_prices"])) {

            $decoded =
                json_decode(
                    $product["size_prices"],
                    true
                );

            if (is_array($decoded)) {
                $size_prices = $decoded;
            }
        }


        $selected_size =
            trim($custom["size"]);


        if (
            !isset(
                $size_prices[$selected_size]
            )
        ) {
            echo json_encode([
                "success" => false,
                "message" =>
                    "Invalid cake size selected for " .
                    $product["name"]
            ]);

            exit;
        }


        $price =
            floatval(
                $size_prices[$selected_size]
            );
    }


    /*
    |--------------------------------------------------------------------------
    | Calculate item total
    |--------------------------------------------------------------------------
    */

    $item_total =
        $price * $quantity;

    $total += $item_total;


    /*
    |--------------------------------------------------------------------------
    | Store item
    |--------------------------------------------------------------------------
    */

    $order_items[] = [
        "product_id" =>
            intval($product["id"]),

        "product_name" =>
            $product["name"],

        "price" =>
            $price,

        "quantity" =>
            $quantity,

        "customization" =>
            $custom
    ];
}


/*
|--------------------------------------------------------------------------
| Check valid items
|--------------------------------------------------------------------------
*/

if (empty($order_items)) {

    echo json_encode([
        "success" => false,
        "message" =>
            "No valid products were found in your cart."
    ]);

    exit;
}


/*
|--------------------------------------------------------------------------
| Create order
|--------------------------------------------------------------------------
*/

$stmt = $conn->prepare("
    INSERT INTO orders
    (
        customer_name,
        phone,
        email,
        city,
        address,
        delivery_date,
        payment_method,
        payment_reference,
        custom_notes,
        total_amount
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
");

if (!$stmt) {

    echo json_encode([
        "success" => false,
        "message" =>
            "Could not prepare order insert: " .
            $conn->error
    ]);

    exit;
}


$stmt->bind_param(
    "sssssssssd",
    $customer_name,
    $phone,
    $email,
    $city,
    $address,
    $delivery_date,
    $payment_method,
    $payment_reference,
    $custom_notes,
    $total
);


if (!$stmt->execute()) {

    echo json_encode([
        "success" => false,
        "message" =>
            "Could not place your order: " .
            $stmt->error
    ]);

    exit;
}


$order_id =
    $conn->insert_id;

$stmt->close();


/*
|--------------------------------------------------------------------------
| Save order items
|--------------------------------------------------------------------------
*/

foreach ($order_items as $item) {

    $product_id =
        $item["product_id"];

    $product_name =
        $item["product_name"];

    $price =
        $item["price"];

    $quantity =
        $item["quantity"];

    $customization =
        json_encode(
            $item["customization"],
            JSON_UNESCAPED_UNICODE
        );


    $stmt = $conn->prepare("
        INSERT INTO order_items
        (
            order_id,
            product_id,
            product_name,
            unit_price,
            quantity,
            customization
        )
        VALUES (?, ?, ?, ?, ?, ?)
    ");


    if (!$stmt) {

        echo json_encode([
            "success" => false,
            "message" =>
                "Could not save order items: " .
                $conn->error
        ]);

        exit;
    }


    $stmt->bind_param(
        "iisdiss",
        $order_id,
        $product_id,
        $product_name,
        $price,
        $quantity,
        $customization
    );


    if (!$stmt->execute()) {

        echo json_encode([
            "success" => false,
            "message" =>
                "Could not save one of the order items: " .
                $stmt->error
        ]);

        exit;
    }


    $stmt->close();
}


/*
|--------------------------------------------------------------------------
| Success
|--------------------------------------------------------------------------
*/

echo json_encode([
    "success" => true,
    "message" =>
        "Your order has been placed successfully!",
    "order_id" =>
        $order_id,
    "total" =>
        $total
]);


$conn->close();

?>