/* 
 Adapted from: http://benfry.com/writing/map/Table.pde
 See also Visualizing Data, Ben Fry, O'Reilly, 2008 (p32)
*/

// Customised Table class to allow processing of data (csv format)
class Table {
  String[][] data;    // set up 2 dimensional array for data
  int rowCount;       // number of rows in table
  
  // constructor method taking filename (of data file) as param
  Table(String filename) {
    String[] rows = loadStrings(filename); // load in data as array of Strings
    data = new String[rows.length][];      // set number of rows for data array
    char separator = ',';                  // set commas as default separator
    
    // loop through each line of data
    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0)
        continue;                         // skip empty rows
      if (rows[i].startsWith("#"))
        continue;                         // skip comment lines
      
      // split the text at every separator character
      String[] pieces = split(rows[i], separator);      
      data[rowCount] = pieces;            // add data to the data array
      rowCount++;
    }
    // resize data array in case rows remain unused
    data = (String[][]) subset(data, 0, rowCount);
  }

  // return the row count (number of rows of data)
  int getRowCount() {
    return rowCount;
  }
    
  // return the String from the given row/column, minus any double quotes
  String getString(int row, int column) {
    return data[row][column].replace("\"", "");  // remove double quotes
  }

  // if expecting an int, return String from row/column as int
  int getInt(int row, int column) {
    return parseInt(getString(row, column));
  }

  // if expecting a float, return String from row/column as float
  float getFloat(int row, int column) {
    return parseFloat(getString(row, column));
  }
  
}
