----------------[ WHEEL ]----------------
create table wheel_category (
    id serial primary key,
    name varchar(50),
    created timestamp not null default now(),
    updated timestamp not null default now()
);
create table wheel (
    id serial primary key,
    name varchar(50) not null,
    brand varchar(50) not null,
    category int not null references wheel_category,
    width real not null,
    height real not null,
    color varchar(50) not null,
    featured bool not null,
    amount_stocked int,
    is_deleted bool not null,
    price money not null,
    description_text text not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);
create table wheel_image (
    id serial primary key,
    wheel_id int not null references wheel,
    image_order int not null,
    image_path varchar(50) not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);

----------------[ USER ]----------------
create type user_role as enum('CUSTOMER', 'ADMIN');
create table Users (
    id serial primary key,
    role user_role not null,
    username varchar(20) not null,
    password varchar(300) not null,
    email varchar(50) not null,
    phone_number varchar(50) not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);
create table reviews (
    id serial primary key,
    user_id int references users,
    wheel_id int not null references wheel,
    stars smallint not null,
    review_text text not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);

----------------[ SHOPPING CART ]----------------
create table shopping_cart (
    id serial primary key,
    user_id int references users, -- moze byt null pre non-logged-in pouzivatela
    subtotal_price money not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);
create table shopping_cart_item (
    id serial primary key,
    wheel_id int not null references wheel,
    shopping_cart_id int not null references shopping_cart,
    amount int not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);

----------------[ ORDER ]----------------
create type payment_method as enum ('CARD', 'BANK_TRANSFER', 'CASH');
create type transport_method as enum ('DOBIERKA', 'DPD', 'PACKETA');
create type order_status as enum ('PENDING', 'PAID', 'SHIPPED');
create table billing_info (
    id serial primary key,
    email varchar(50) not null,
    country varchar(50) not null,
    house_number varchar(10) not null,
    street varchar(100) not null,
    city varchar(100) not null,
    post_code varchar(10) not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);
create table payment_info (
    id serial primary key,
    card_holder_name varchar(100) not null,
    card_number bigint not null,
    card_expiration_date date not null,
    card_ccv smallint not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);
create table orders (
    id serial primary key,
    user_id int references users,
    final_price money not null,
    payment_method payment_method not null,
    transport_method transport_method not null,
    billing_info_id int not null references billing_info,
    payment_info_id int not null references payment_info,
    status order_status not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);
create table order_items (
    id serial primary key,
    order_id int not null references orders,
    wheel_id int not null references wheel,
    amount int not null,
    created timestamp not null default now(),
    updated timestamp not null default now()
);

