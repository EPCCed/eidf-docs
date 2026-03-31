# Accessing Databases

Some data in Safe Havens may be accessible via a database rather than files.

If you have a project with database access, your Research Coordinator will arrange for your accounts to be created on the database. Once your account is created, you will receive the `database name`, `host` and `port`, which you can use to connect programmatically (i.e., via R, Python, or any other language).

## R

To connect to a Safe Haven database via R, follow the [official documentation](https://solutions.posit.co/connections/db/getting-started/connect-to-database/) on database connections. The required connection packages will depend on the [type of database](https://solutions.posit.co/connections/db/databases/).

Example connection to a PostgreSQL database via [RPostgres](https://solutions.posit.co/connections/db/databases/postgresql/#using-the-rpostgres-package):

```r
> library(DBI)
> library(RPostgres)
> con <- dbConnect(
    RPostgres::Postgres(),
    dbname = "<database-name>",
    host="<host-name>",
    port="<port-number>",
    user = .rs.askForPassword("Enter Username:"),
    password = .rs.askForPassword("Enter Password:")
)
```

Alternatively, you may wish to use RStudio's [new Connections interface](https://solutions.posit.co/connections/db/tooling/connections/). First, check that the PostgreSQL driver is installed using `odbc::odbcListDrivers()`:

```r
> library(DBI)
> odbc::odbcListDrivers()
                 name   attribute                                    value
1     PostgreSQL ANSI Description    PostgreSQL ODBC driver (ANSI version)
2     PostgreSQL ANSI      Driver                             psqlodbca.so
3     PostgreSQL ANSI       Setup                          libodbcpsqlS.so
4     PostgreSQL ANSI       Debug                                        0
5     PostgreSQL ANSI     CommLog                                        1
6     PostgreSQL ANSI  UsageCount                                        1
7  PostgreSQL Unicode Description PostgreSQL ODBC driver (Unicode version)
8  PostgreSQL Unicode      Driver                             psqlodbcw.so
9  PostgreSQL Unicode       Setup                          libodbcpsqlS.so
10 PostgreSQL Unicode       Debug                                        0
11 PostgreSQL Unicode     CommLog                                        1
12 PostgreSQL Unicode  UsageCount                                        1
```

If no drivers are listed, then you must ask your Research Coordinator for the `odbc-postgresql` system package to be installed. Once this is complete, a connection can be established using the following `dbConnect` call. Note that this is different to the `RPostgres` method above:

```r
> library(DBI)
> con <- dbConnect(
  odbc::odbc(),
  driver = "PostgreSQL Unicode",
  Server = "<host-name>",
  Port = 5432,
  Database = "<database-name>",
  UID = .rs.askForPassword("Enter Username:"),
  PWD = .rs.askForPassword("Enter Password:"),
)
```

If successful, the connection should now be shown in the Connections pane.

## Python

Python has many database connection packages depending on the type of database. We recommend you choose a highly supported package and follow the package's official documentation.

Example connection to a PostgreSQL database via [psycopg](https://www.psycopg.org/docs/index.html):

1. Install psycopg2

    ```console
    $ pip install psycopg2
    ```

1. Connect

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
