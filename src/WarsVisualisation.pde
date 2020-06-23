// WarsVisualisation.pde - plots wars sized by casualties along a timeline 1800--2000

String data_src = "wars.csv";   // the data file to be used
Table warTable;                 // declare table object to hold data (see class Table)
int rowCount;                   // to store how many rows there are in the table

color col1 = #0000ff;           // use blue as start of range for lerpColor function
color col2 = #ff0000;           // use green as end of range for lerpColor function
int dataMin = MAX_INT;          // for holding the max and min death counts
int dataMax = MIN_INT;
float ratio;                    // for holding the ratio between max and min

void setup() {
  size(1840, 600);              // set up sketch display window
  background(#000000);          // set background to black

  warTable = new Table(data_src);   // create new table from data file
  rowCount = warTable.getRowCount();
  
  PFont font;
  font = createFont("Arial",16,true);
  textFont(font, 32);
  fill(#ffffff);
  
  // draws the two horizontal lines
  stroke(#ffffff);
  line(20,200,1820,200);
  line(20,400,1820,400);
  int labelY1 = 190;
  int labelY2 = 390;
  // draws the vertical incremental lines
  for(int div = 20, year = 1800; div <= 1823; div = div + 9, year++) {
    textAlign(CENTER);
    textSize(8);
    line(div,197,div,203);
    line(div,397,div,403);
    if (year % 2 == 0) {
      text(year,div,labelY1);
      if (labelY1 == 190) labelY1 = 215;
      else labelY1 = 190;    
      text(year,div,labelY2);
      if (labelY2 == 390) labelY2 = 415;
      else labelY2 = 390; 
    }
    textAlign(LEFT) ;
    textSize(14);
    text("Wars 1800--2000, sized by # of deaths", 20, 160);
    text("Wars 1800--2000, coloured by # of deaths", 20, 360);
  }
   
  // loop through each row of data
  // ignoring row 0, the 'header'
  for(int row = 1; row < rowCount; row++) {
    int deaths = warTable.getInt(row, 15);
   
    if (deaths > dataMax)
      dataMax = deaths;
    if (deaths < dataMin)
      dataMin = deaths;
    ratio = dataMax/dataMin; 
  }
  
  int yrBeg, yrEnd, deaths;
  int offset = 0;
  
  // populates the values for the wars
  for(int row = 1; row < rowCount; row++) {
    yrBeg = warTable.getInt(row, 2);
    yrEnd = warTable.getInt(row, 5);
    deaths = warTable.getInt(row, 15);
    float percent = norm(deaths, dataMin, dataMax);
    float newPercent = lerp(0,500,percent);
    // draws the sized top line values
    stroke(200,50);
    strokeWeight(newPercent);
    line(yearToLine(yrBeg), 200, yearToLine(yrEnd), 200);
    
    // colours the bottom line values
    stroke(lerpColor(#61e2f0, #296f34, percent, HSB));
    strokeWeight(5);
    line(yearToLine(yrBeg), 400, yearToLine(yrEnd), 400);
    
    // adds a label for the war, with an offset
    // that means no labels overlap
    textSize(9);
    text(warTable.getString(row, 1), yearToLine(yrBeg), 440+offset);
    offset = offset + 10;
    if (offset == 100) offset = 0;
  }
  
}

// converts a year to an x-coord
int yearToLine(int year) {
  return (year - 1800)*9; 
}
