# Design Document

By Mohammad Haadi Goolfee



## Scope

The purpose of this project is to facilitates a lending system of a library to its members in such a way that the database keeps tracks of:
1. Which member has which books?
2. How many books has a member borrowed?
3. When was the book lended and when it should be returned?
4. If there is an overdue payment for late return, by how many days and how much is the overdue?

Additional information that are also kept in the databases are:
1. Biography of authors which are not compulsory to include.
2. Number of copies of each book that the library has in store.
3. The language of each book that the library has.
4. Adding comments to the transaction such as state of the books returned and comments on members.


Those information are kept in different tables namely:
`authors` table - contains information about authors
`books` table -  contains information about books
`members` table - contains information about members who joined library
`borrow` table - contains information about the borrow transaction of members keeping track of date and time
`borrow_details` table -  contains information about the borrow transaction in terms of days overdue and amount overdue for each transaction and book together. Additionally comments can be added to the transaction regarding the state of the book returned, or regarding the person itself.

The financial details and aspects of the transactions and members are not in the scope of this databases and therefore is assumed to be available as part of another database which the library has access to.
Access to which employee who has conducted and apporved a transaction for lending books to members is also out of the scope of the database.


## Functional Requirements

This database allow the following actions to be performed:
* Library employees should be able to perform CRUD operations for members of the library, contents of books and authors.
* They should be able to keep track of books which have been lent to different members.
* They should also be able to track outstanding, total return of books and the amount due for each lending transaction.

* The user cannot identify the return state of the book which is being returned as there is no initial state registered for the book when being lent.

## Representation

### Entities

The database has 5 Entities which are:

### Authors

The `authors` table contains the following columns:

* `author_id` - which takes integer values and has the primary constraint and therefore is the unique id for each author and by default has an autoincrement and not null value.
* `first_name` - is the first name of author which is in text format as it takes in string of characters and has the constrain of not null to enforce a first name.
* `last_name` - is the last name of author which is in text format as it takes in string of characters and has the constrain of not null to enforce a last name,
* `biography` - is in text format and contains additional information about the author stored in the database should people require more general information. If the biography is left empty, the default value of is null as it is comprehensible that not all authors will have their biography written down in the database

### Books

The `books` - table contains the following columns:

* `book_id`-  It takes integer values and has the primary key constraint and therefore is unique as id for each book and by default has an autoincrement and not null value.
* `author_id` - It is a foreign key in the `books` table which references the author table. It has a constraint of ON DELETE SET NULL since if the data in author is deleted for   author, the data in the books is still present but referenced as a null `author_id`
* `title` - It is the name of the book. takes text as input as it is just a static string.  it has the constraint of NOT NULL as every book needs a title.
* `genre` - It is the type of content for which they book is idenfied as. It takes text as input. The constraint for DEFAULT value is a string 'unidentified' in case no genre is input
* `book_language` - Defines the language in which the book was written. It takes text as input and has NOT NULL as constraint as each book needs to have the identified language written.
* `published_date` - takes text as input for the date it was published, in the format 'yyyy-mm-dd'. It has the constraint of DEFAULT NULL if the published year cannot be determined
* `available_copies` - it is used to know how many available copies of a specific book is available at the library. It takes integer as values and has a default value of 0 since the minmimum amount of books that can be reached is zero.

### Member

The `lib_members` table contains the following columns:

* `member_id` - It is the primary key which identifies the members of the library community.
* `first_name` - The first name of the member which takes as input text characters. It takes NOT NULL as constraints since a first name is mandatory for a member.
* `last_name` - The last name of the member which takes as input text characters. It takes NOT NULL as constraints since a last name is mandatory for a member.
* `birth_date` - The birthday of the member for which the input is date in the format 'yyyy-mm-dd'.
* `nationality` - The nationality of the person which identifies if the person is a local or from a different country. it takes text as input
* `address` - The address of the member which takes text as input. There has to be a mandatory address for each member when following an input in the table.
* `email` - The email address of the member. It takes as default a null value if no email is provided.
* `phone` - A phone number for the member is required as the email is not mandatory for communication, therefore the constraint is NOT NULL.
* `occupation` - The occupation highlights if the member is a 'student' or 'e'mployed' or 'unemployed'. This allows the library staff to know if there is any discount or offer for students members. the column takes a not null value as input and check if it is in the ranges of the three categories mentioned.

### Borrow

The `borrow` table contains the following columns:

* `borrow_id` - The borrow_id is the unique id that identifies the transaction for a member, therefore it is a primary key for this table
* `member_id` - It is a foreign key which references the member in the 'lib_members' table by the member_id. It links the member details with the transaction of borrowing. It also takes the constraint of ON DELETE CASCADE if a member is deleted/retired from the member table, the borrowing transaction related to that member is deleted from the record. It also takes the constraint of ON UPDATE CASCADE whereby if the row for that member is updated in the members table, the updated data is done on the borrow table.
* `borrow_date` - It refers to the date which the transaction was commited by the member. It takes text as input in the format of date with a default value of the current time stamp if there is no value inserted.
* `due_date` -It refers to the date which the member should return the book. Therefore it takes a NOT NULL constraint as there should be a deadline for the return.
* `return_date` - It refers to the actual date which the member returns the book with the same format of `borrow_date` and constraints
* `total_books_borrowed` - It refers to the number of books that a member has borrowed from the library. The default value is 0 since a member can end up with having no book borrow after updating the record when returning books.


### Borrow_details

The `borrow_details` table contains the following columns:

* `borrow_id` - It is a foreign key which refers to the id in the borrow table. It is also part of a compound of a primary key which identifies the details in the borrow_table. It has a constraint of ON DELETE CASCADE because if the entry in the borrow table is deleted, the input in borrow_details also needs to be removed. Same goes for update.
* `book_id` - It is a foreign key which referes to the id of the book in the books table. Together with the borrow_id, they identify the transaction and the book required for the row in the borrow_details.It has a constraint of ON DELETE CASCADE because if the entry in the borrow table is deleted, the input in borrow_details also needs to be removed. Same goes for update.
* `overdue_type` - It represents if there is an outstanding of the member for books. It takes only two values yes or no since it simplifies the search for a broader view.
* `overdue_days` - It represents the number of days which the outstanding transaction is overdue by a member.
* `overdue_amount` - It representes the amount for the current overdue transaction depending on the days overdue.
* `comments` - Users can include additional comments on the status of the book returned and the overdue payment or any other type of comments for further reference. It can also be left empty.



### Relationships
![ER Diagram](relation_diagram.png)

* The relationship of the entities in the diagram is as follows:
* An Author can contributes to one to many books.
* A Book can have one to many authors.
* A Book can have only one Borrow-Detail. it cannot have zero since it is a borrow system.
* A Borrow-Detail can have one to many books.
* A Member can make zero to many Borrow.
* A Borrow can have only one Member.
* A Borrow contains one to many Borrow-Detail.
* A Borrow-Detail can only be done for one Borrow.

## Optimizations

* Based on the search that will be conducted on the database, a lot of queries will be done on the borrow_details table, creating an index on the book_id in the borrow_details table will optimize and speed up the search for outstandings and amount due.
* The same way to optimize the speed of search in the borrow table, an index is created on the member_id as a lot of queries will be done by the member_id.
* Another index created is on the overdue_type from the borrow_details since it will be used often to search members who have overdue.


## Limitations

* A major limitation of  this integrated database in 2024 is that there is no application for electronic books. The books which are stored in the database is only available in physical copies. To accomodate ebooks into the lending systems, the databases should expand horizontally. It should at least take the following points into consideration:
A subscription database with two main tables for:
1. ebook table- available electronic copies of books, the format of the book, a url for the content of the ebook
2. digitalborrow table - subscribed members and duration of subscription, access to the portal for digital return and borrow, with a maximum number of borrowed books

* Since the focus of the database in towards lending and borrowing of books, finding the books inside of the library itself is not well represented by the system. Therefore, there will be a lot of books which are not part of the transaction for borrowing. The states of the books with which they are lent and returned are not well represented by the database. If the states were registered, it would be better to know which books need to be discarded or service at the same time give a better understanding of the analytics of members and how they treat the books given to them.
