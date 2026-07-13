# Database Keys

## What is a key?

A **key** is a column (or set of columns) used to identify rows and to express
relationships between tables. Keys guarantee we can find a specific record
uniquely and link data across tables reliably.

## Types of keys

### 1. Primary Key (PK)
- A column (or combination) that **uniquely identifies** each row in a table.
- Must be **unique** and **NOT NULL**.
- A table can have exactly **one** primary key (though it may span multiple columns).
- In Chinook, most tables use an auto-incrementing integer PK (e.g. `CustomerId`).

### 2. Foreign Key (FK)
- A column in one table that **references the primary key** of another table.
- Establishes the relationship/parent–child link between tables.
- In Chinook FKs are declared with `REFERENCES ...` (e.g. `invoices.CustomerId → customers.CustomerId`).

### 3. Composite / Compound Key
- A primary key made of **two or more columns** together.
- Used when no single column is unique on its own.
- In Chinook, `playlist_track` has a composite PK on `(PlaylistId, TrackId)` — a track can appear in many playlists, and a playlist holds many tracks, so both are needed to be unique.

### 4. Candidate Key
- Any column (or set) that could serve as the primary key — i.e. it is unique and non-null.
- The chosen candidate becomes the PK; the others remain **alternate keys**.
- Example candidate in Chinook: `customers.Email` is unique per customer and could act as a key (but `CustomerId` is chosen as PK).

### 5. Super Key
- Any set of columns that uniquely identifies a row (superset of a candidate key).
- E.g. `(CustomerId, Email)` is a super key because `CustomerId` alone already identifies the row.

### 6. Unique Key
- Enforces uniqueness like a PK but allows **one NULL** and a table may have many.
- Declared with `UNIQUE`. (Chinook does not add extra `UNIQUE` constraints beyond PKs, but `Email` is naturally unique.)

### 7. Surrogate Key vs Natural Key
- **Surrogate (artificial) key:** a system-generated value with no business meaning (e.g. `AlbumId`, `TrackId`). Chinook uses surrogate integer PKs almost everywhere.
- **Natural key:** a real-world attribute that is inherently unique (e.g. an email address, a country code).

### 8. Self-Referencing Key
- A foreign key that points back into the **same** table.
- In Chinook, `employees.ReportsTo` references `employees.EmployeeId` to model the management hierarchy.

## Keys found in the Chinook database

| Table | Primary Key | Foreign Keys (references) |
|-------|-------------|---------------------------|
| `artists` | `ArtistId` | — |
| `albums` | `AlbumId` | `ArtistId` → `artists(ArtistId)` |
| `customers` | `CustomerId` | `SupportRepId` → `employees(EmployeeId)` |
| `employees` | `EmployeeId` | `ReportsTo` → `employees(EmployeeId)` (self-referencing) |
| `genres` | `GenreId` | — |
| `media_types` | `MediaTypeId` | — |
| `tracks` | `TrackId` | `AlbumId` → `albums(AlbumId)`, `GenreId` → `genres(GenreId)`, `MediaTypeId` → `media_types(MediaTypeId)` |
| `playlists` | `PlaylistId` | — |
| `playlist_track` | **composite** `(PlaylistId, TrackId)` | `PlaylistId` → `playlists(PlaylistId)`, `TrackId` → `tracks(TrackId)` |
| `invoices` | `InvoiceId` | `CustomerId` → `customers(CustomerId)` |
| `invoice_items` | `InvoiceLineId` | `InvoiceId` → `invoices(InvoiceId)`, `TrackId` → `tracks(TrackId)` |

**Observations**
- Every table has a single-column surrogate integer PK **except** `playlist_track`, which uses a **composite PK**.
- The `employees` table demonstrates a **self-referencing FK** (`ReportsTo`).
- Lookup/reference tables (`artists`, `genres`, `media_types`, `playlists`) have no outgoing FKs — they are the "parents" at the top of the relationship graph.
- `tracks` is the most connected table: it is referenced by `invoice_items` and `playlist_track`, and itself references three parent tables.

## How the tables connect (relationship map)
- `artists` 1—N `albums` 1—N `tracks` N—1 `genres` / `media_types`
- `tracks` N—N `playlists` via the junction table `playlist_track`
- `customers` 1—N `invoices` 1—N `invoice_items` N—1 `tracks`
- `employees` 1—N `customers` (support rep) and a self hierarchy via `ReportsTo`

## References
- SQLite PRIMARY KEY: https://www.sqlite.org/lang_createtable.html#primkeyconst
- SQLite FOREIGN KEY: https://www.sqlite.org/foreignkeys.html
- GeeksforGeeks – Types of Keys: https://www.geeksforgeeks.org/sql/keys-in-sql/
- SQLiteTutorial – PRIMARY KEY: https://www.sqlitetutorial.net/sqlite-primary-key/
