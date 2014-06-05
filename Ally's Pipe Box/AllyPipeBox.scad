function woodThickness()=3.175;
function boxWidth()=200;
function boxDepth()=140;
function boxHeight()=140;

function topWidth()=boxWidth();
function topDepth()=boxDepth();
function topHeight()=woodThickness();

function frontWidth()=boxWidth();
function frontDepth()=woodThickness();
function frontHeight()=boxHeight();

function backWidth()=boxWidth();
function backDepth()=woodThickness();
function backHeight()=boxHeight();

function bottomWidth()=boxWidth();
function bottomDepth()=boxDepth();
function bottomHeight()=woodThickness();

function leftWidth()=woodThickness();
function leftDepth()=boxDepth();
function leftHeight()=boxHeight();

function rightWidth()=woodThickness();
function rightDepth()=boxDepth();
function rightHeight()=boxHeight();

function tabWidth()=15;
function tabDepth()=woodThickness();
function tabHeight()=10;

function pinWidth()=woodThickness();
function pinDepth()=woodThickness();
function pinHeight()=15;

module fillet(r=woodThickness(),h=woodThickness()) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}

module tab(){
	difference(){
		cube([tabWidth(),tabDepth(),tabHeight()]);
		#fillet();
	}
}

module frontSide(){
	cube([frontWidth(),frontDepth(),frontHeight()]);
}

tab();