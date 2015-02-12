WAREHOUSE.results_as_hash = true
WAREHOUSE.execute("CREATE TABLE IF NOT EXISTS products
                   (id INTEGER PRIMARY KEY,
                    category_id INTEGER,
                    location_id INTEGER)")
WAREHOUSE.execute("CREATE TABLE IF NOT EXISTS categories
                   (id INTEGER PRIMARY KEY,
                    name TEXT,
                    description TEXT,
                    cost INTEGER)")
WAREHOUSE.execute("CREATE TABLE IF NOT EXISTS locations
                   (id INTEGER PRIMARY KEY,
                    name TEXT,
                    capacity INTEGER)")