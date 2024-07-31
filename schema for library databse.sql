-- Authors Table
CREATE TABLE authors (
    "author_id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "biography" TEXT DEFAULT NULL,
    PRIMARY KEY ("author_id")
);

-- Books Table
CREATE TABLE books (
    "book_id" INTEGER,
    "author_id" INTEGER,
    "title" TEXT NOT NULL,
    "genre" TEXT DEFAULT 'unidentified',
    "book_language" TEXT NOT NULL,
    "published_date" TEXT DEFAULT NULL,
    "available_copies" INTEGER DEFAULT 0,
    PRIMARY KEY("book_id"),
    FOREIGN KEY ("author_id") REFERENCES "authors" ("author_id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- Members Table
CREATE TABLE lib_members (
    "member_id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "birth_date" TEXT NOT NULL,
    "nationality" TEXT DEFAULT NULL,
    "address" TEXT NOT NULL,
    "email" TEXT DEFAULT NULL,
    "phone" TEXT NOT NULL,
    "occupation" TEXT NOT NULL CHECK("occupation" IN('employed','student','unemployed')),
    PRIMARY KEY("member_id")
);

-- Borrow Table
CREATE TABLE borrow (
    "borrow_id" INTEGER,
    "member_id" INTEGER NOT NULL,
    "borrow_date" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "due_date" TEXT NOT NULL,
    "return_date" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "total_books_borrowed" INTEGER DEFAULT 0,
    PRIMARY KEY("borrow_id"),
    FOREIGN KEY ("member_id") REFERENCES "lib_members" ("member_id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- Borrow_Details Table
CREATE TABLE borrow_details (
    "borrow_id" INTEGER,
    "book_id" INTEGER,
    "overdue_type" TEXT NOT NULL CHECK ("overdue_type" IN ('yes','no')),
    "overdue_days" TEXT DEFAULT NULL,
    "overdue_amount" REAL DEFAULT NULL,
    "comments" TEXT DEFAULT NULL,
    PRIMARY KEY ("borrow_id", "book_id"),
    FOREIGN KEY ("borrow_id") REFERENCES "borrow" ("borrow_id") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("book_id") REFERENCES "books" ("book_id") ON DELETE CASCADE ON UPDATE CASCADE
);
