BUILD_DIR = build
SOURCES = $(wildcard src/*cxx)
TEST_SOURCES = $(wildcard tests/*.cxx)

# Debugging flags
CFLAGS = -pthread -ldl --std=c++11 -Og -g --coverage

# Compiled Objects
SQLITE3 = $(BUILD_DIR)/sqlite3.o
SQLITE_CC = $(BUILD_DIR)/sqlitecc.o

# SQLite3
$(SQLITE3):
	mkdir -p $(BUILD_DIR)
	$(CC) -c -o $(BUILD_DIR)/sqlite3.o -O3 lib/sqlite3.c -pthread -ldl -Ilib/

# Main Library
$(SQLITE_CC):
	mkdir -p $(BUILD_DIR)
	$(CC) -c -o $(SQLITE_CC) $(SQLITE3) $(SOURCES) -Isrc/ $(CFLAGS)

test_sqlite: $(SQLITE3) $(SQLITE_CC)
	$(CXX) -o $(BUILD_DIR)/test_sqlite $(TEST_SOURCES) $(SQLITE3) $(SQLITE_CC) $(CFLAGS) -Ilib/ -Isrc/ -Itests/
	$(BUILD_DIR)/test_sqlite

code_cov: test_sqlite
	mkdir -p test_results
	mv $(BUILD_DIR)/*.gcno $(BUILD_DIR)/*.gcda $(PWD)/test_results
	gcov $(SOURCES) -o test_results --relative-only
	mv *.gcov test_results

clean:
	rm -rf build
	rm -f test_sqlite
