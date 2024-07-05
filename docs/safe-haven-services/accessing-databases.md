# Accessing Databases

Some data in Safe Havens may be accessible via a database rather than files.

If you have a project with database access, your Research Coordinator will arrange for your accounts to be created on the database. Once your account is created, you will receive the `database name`, `host` and `port`, which you can use to connect programmatically (i.e., via R, Python, or any other language).

## R

To connect to a Safe Haven database via R, follow the [official documentation](https://solutions.posit.co/connections/db/getting-started/connect-to-database/) on database connections. The required connection packages will depend on the [type of database](https://solutions.posit.co/connections/db/databases/).

Example connection to a PostgreSQL database via [RPostgres](https://solutions.posit.co/connections/db/databases/postgresql/#using-the-rpostgres-package):

```r
library(DBI)
library(RPostgres)
con <- dbConnect(
    RPostgres::Postgres(),
    dbname = "<database-name>",
    host="<host-name>",
    port="<port-number>",
    user = .rs.askForPassword("Enter Username:"),
    password = .rs.askForPassword("Enter Password:")
)
```

## Python

Python has many database connection packages depending on the type of database. We recommend you choose a highly supported package and follow the package's official documentation.

Example connection to a PostgreSQL database via [psycopg](https://www.psycopg.org/docs/index.html):

1. Install psycopg2

    ```console
    $ pip install psycopg2
    ```

2. Connect

    ```python
    import psycopg2

    con = psycopg2.connect(
        database = "<database-name>",
        host="<host-name>",
        port="<port-number>",
        user=input("Enter Username:"),
        password=input("Enter Password:")
    )
    ```
