-- created all tables 

CREATE TABLE table_name AS SELECT * FROM read_csv_auto('csv_file_name.csv')

-- sanity check 

SELECT * FROM table_name 

-- checking for NULLs 

SELECT * FROM table_name WHERE col1 IS NULL OR col2 IS NULL...