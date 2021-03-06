//This project is a birthday gift for Allison, my beloved girlfriend.
//It is a custom fit box for a pipe, to be cut from wood on a laser cutter.
//The design is based off another open-source design a friend of mine emailed to me.  I do not know the original source.
//I redesigned the whole thing from scratch in openSCAD using the other design as a guide.
//Feel free to reuse and modify, but please share and share alike.
//This is my first project not explicitly for practice and I don't have formal training.  I hope you find my design/code useable.
//Cheers, Nick

//Independant Variables
function woodThickness() = 3.175;
//The following are the desired box's internal dimensions.  Thanks to a suggestion by Jansen.
function boxWidth() = 200;
function boxDepth() = 140;
function boxHeight() = 140;
function footHeight() = 1/5 * boxHeight();

//Dependant Variables
//Each dimension is described in terms of the independant variables above.
//Each side is described as if you were holding the box looking at that side, with up facing up.
//The bottom is the same, with up facing the front.  Top is the same with up facing the back.
//I did this to make it easier to model each side in SCAD before translating/rotating everything into place.

//topSide
function topWidth() = boxWidth();
function topDepth() = woodThickness();
function topHeight() = boxHeight();

//frontSide
//Eliminated backSide by adding some conditionals to frontSide.
function frontWidth() = boxWidth();
function frontDepth() = woodThickness();
function frontHeight() = boxHeight() + woodThickness();

//bottomSide
function bottomWidth() = boxWidth();
function bottomDepth() = woodThickness();
function bottomHeight() = boxDepth();

//leftSide 
//Left and right sides are identical, simply make two leftSides.
function leftWidth() = boxDepth();
function leftDepth() = woodThickness();
function leftHeight() = boxHeight();

//tab
function tabWidth() = 5 * woodThickness();
function tabDepth() = woodThickness();
function tabHeight() = 3 * woodThickness();

//pin
function pinWidth() = 2 * woodThickness();
function pinDepth() = woodThickness();
function pinHeight()= 5 * woodThickness();

//This module was copied from the internet.  Credit to: nophead (6/6/14), http://forum.openscad.org/rounded-corners-td3843.html
module fillet(r=woodThickness(),h=woodThickness()+0.1){
//Made r and h functions of woodThickness, by default.
    translate([r/2,r/2,r/2])
        difference(){
            cube([r+0.1,r+0.1,h],center=true);
            translate([r/2,r/2,0])
                cylinder(r=r,h=h+1,center=true);

        }
}
//End of copied nophead code.

module pin(w=pinWidth(),d=pinDepth(),h=pinHeight()){
	difference(){
		cube([w,d,h]);
		translate([0,d,0]){
			rotate([90,0,0]){
				scale([1/2,1/2,1]){
					fillet();
				}
			}
		}
		translate([0,0,(3/5*h)]){
			rotate([-90,0,0]){
				scale([1/2,1/2,1]){
					fillet();
				}
			}
		}
		translate([-0.1,-0.1,(3/5*h)]){
			rotate([0,0,0]){
				cube([((w/2)+0.1),(d+0.2),((2/5*h)+0.1)]);
			}
		}
	}
}

//To compile to projection, made tabs 0.1 taller, and offset them by the same.
module tab(w=tabWidth(),d=tabDepth(),h=(tabHeight())){
	difference(){
		translate([0,0,-0.1]){
			cube([w,d,(h+0.1)]);
		}
		translate([0,0,h]){
			rotate([-90,0,0]){
				fillet();
			}
		}
		translate([w,d,h]){
			rotate([-90,0,180]){
				fillet();		
			}
		}
		translate([((pinDepth()+w)/2),-(3/5*pinHeight()),pinWidth()+woodThickness()]){
			rotate([-90,90,0]){
				pin();
			}
		}
	}
}

//Tabslot is slightly bigger than a tab, to get rid of the wierd 0 width bugs in openSCAD.
//It also has no pin hole, making it better for the subtractions.
module tabSlot(w=tabWidth(),d=tabDepth(),h=tabHeight()){
	cube([(w+0.1),(d+0.1),(h+0.1)]);
}	

//The wideTab adds to the side dimensions in ceratin places to add enough lip to create slots for tabs.
//Default w (width) is 1, you'll want to set the width each time you call the wideTab
module wideTab(w=1,d=woodThickness(),h=woodThickness(),rfillet=true){
	difference(){
		translate([0,0,-0.1])cube([w,d,h+0.1]);
		translate([0,0,h]){
			rotate([-90,0,0]){
				fillet();
			}
		}
		if(rfillet==true){
			translate([w,d,h]){
				rotate([-90,0,180]){
					fillet();	
				}	
			}
		}
	}
}

//Hinge hole punch
module hinge(h=woodThickness(),d=tabWidth()+2*woodThickness(),center=false){
	difference(){
		cylinder(h=h+0.2,r=(d/2));
		translate([0,0,-0.1]){
			cylinder(h=h+0.4,r=(d/2)-0.1);
		}
	}
}

module frontFoot(){
	difference(){
		translate([0,0,0.1]){
			cube([frontWidth(),frontDepth(),footHeight()+0.1]);
		}
		translate([(1/2*frontWidth()),-0.1,-frontWidth()+(1/2*woodThickness())+(2/3*footHeight())]){
			rotate([-90,0,0]){
				cylinder(h=frontDepth()+0.2,r=frontWidth(),center=false);
			}
		}
	}
}

module leftFoot(){
	difference(){
		translate([0,0,-0.1]){
			cube([leftWidth(),leftDepth(),footHeight()+0.1]);
		}
		translate([(1/2*leftWidth()),-0.1,-leftWidth()+(1/2*woodThickness())+(1/2*footHeight())]){
			rotate([-90,0,0]){
				cylinder(h=leftDepth()+0.2,r=leftWidth(),center=false);
			}
		}
	}
}

module frontCut(w=frontWidth()+0.2,d=(woodThickness()+0.2),h=0.1){
	cube([w,d,h]);
}

module leftCut(){
	union(){
		translate([-0.1,0,0]){
			rotate([0,0,0]){
				cube([leftWidth(),(woodThickness()+0.2),0.1]);
			}
		}
		translate([0,0,0]){
			rotate([0,atan2((1/2*leftHeight()),(leftWidth()-(16*woodThickness())))-180,0]){
				cube([(sqrt(((leftWidth()-(16*woodThickness()))*(leftWidth()-(16*woodThickness())))+((1/2*leftHeight())*(1/2*leftHeight())))),(woodThickness()+0.2),0.1]);
			}
		}
		translate([-(leftWidth()-(16*woodThickness())),0,(1/2*leftHeight())-0.1]){
			rotate([0,-90,0]){
				cube([leftHeight(),(woodThickness()+0.2),0.1]);
			}
		}
	}
}

module topSide(w=topWidth(),d=topDepth(),h=topHeight()){
	//This translate/rotate is for laying out the pieces to create a .dxf file.
	translate([0,0,0]){
		rotate([0,0,0]){
			union(){
				cube([w,d,h]);
				//Two tabs sit in the top corners to form the hinges of the box.
				translate([0,0,(h-tabWidth())]){
					rotate([0,-90,0]){
						tab();
					}
				}
				translate([w,0,h]){
					rotate([0,90,0]){
						tab();
					}
				}
				//First group of three are the left side tabs which join to the top of the left side.
				translate([0,0,(1/4*h)-(1/2*tabWidth())]){
					rotate([0,-90,0]){
						tab();
					}
				}
				translate([0,0,(2/4*h)-(1/2*tabWidth())]){
					rotate([0,-90,0]){
						tab();
					}
				}
				translate([0,0,(3/4*h)-(1/2*tabWidth())-woodThickness()]){
					rotate([0,-90,0]){
						tab();
					}
				}
				//Second group of three are the right side tabs which join to the top of the right side.
				translate([w,0,(1/4*h)+(1/2*tabWidth())]){
					rotate([0,90,0]){
						tab();
					}
				}
				translate([w,0,(2/4*h)+(1/2*tabWidth())]){
					rotate([0,90,0]){
						tab();
					}
				}
				translate([w,0,(3/4*h)+(1/2*tabWidth())-woodThickness()]){
					rotate([0,90,0]){
						tab();
					}
				}
				//Third group of four are the front side tabs that join to the top of the front side.
				translate([(1/5*w)-(1/2*tabWidth()),woodThickness(),0]){
					rotate([180,0,0]){
						tab();
					}
				}
				translate([(2/5*w)-(1/2*tabWidth()),woodThickness(),0]){
					rotate([180,0,0]){
						tab();
					}
				}
				translate([(3/5*w)-(1/2*tabWidth()),woodThickness(),0]){
					rotate([180,0,0]){
						tab();
					}
				}
				translate([(4/5*w)-(1/2*tabWidth()),woodThickness(),0]){
					rotate([180,0,0]){
						tab();
					}
				}
			}
		}	
	}
}

module frontSide(w=frontWidth(),d=frontDepth(),h=frontHeight(),top=true){
	union(){
		difference(){
			cube([w,d,h]);
			//These three tabSlots connect with the bottom.
			translate([(1/5*w)-(1/2*tabWidth()),2*woodThickness(),-0.1]){
				rotate([90,0,0]){
					tabSlot();
				}
			}
			translate([(2/5*w)-(1/2*tabWidth()),2*woodThickness(),-0.1]){
				rotate([90,0,0]){
					tabSlot();
				}
			}
			translate([(3/5*w)-(1/2*tabWidth()),2*woodThickness(),-0.1]){
				rotate([90,0,0]){
					tabSlot();
				}
			}
			translate([(4/5*w)-(1/2*tabWidth()),2*woodThickness(),-0.1]){
				rotate([90,0,0]){
					tabSlot();
				}
			}
			//These four tabSlots connect with the top.
			if(top==true){
				translate([(1/5*w)-(1/2*tabWidth()),2*woodThickness(),h-woodThickness()]){
					rotate([90,0,0]){
						tabSlot();
					}
				}
				translate([(2/5*w)-(1/2*tabWidth()),2*woodThickness(),h-woodThickness()]){
					rotate([90,0,0]){
						tabSlot();
					}
				}
				translate([(3/5*w)-(1/2*tabWidth()),2*woodThickness(),h-woodThickness()]){
					rotate([90,0,0]){
						tabSlot();
					}
				}
				translate([(4/5*w)-(1/2*tabWidth()),2*woodThickness(),h-woodThickness()]){
					rotate([90,0,0]){
						tabSlot();
					}
				}
				//Front cut
				translate([-0.1,-0.1,3/8*h]){
					rotate([0,0,0]){
						frontCut();
					}
				}
			}
		}
		//First group of three are the left side tabs.
		translate([0,0,(1/4*h)-(1/2*tabWidth())]){
			rotate([0,-90,0]){
				tab();
			}
		}
		translate([0,0,(2/4*h)-(1/2*tabWidth())]){
			rotate([0,-90,0]){
				tab();
			}
		}
		translate([0,0,(3/4*h)-(1/2*tabWidth())]){
			rotate([0,-90,0]){
				tab();
			}
		}
		//Second group of three are the right side tabs.
		translate([w,0,(1/4*h)+(1/2*tabWidth())]){
			rotate([0,90,0]){
				tab();
			}
		}
		translate([w,0,(2/4*h)+(1/2*tabWidth())]){
			rotate([0,90,0]){
				tab();
			}
		}
		translate([w,0,(3/4*h)+(1/2*tabWidth())]){
			rotate([0,90,0]){
				tab();
			}
		}
		//This is the front foot of the box.
		translate([0,0,-footHeight()]){
			frontFoot();
		}
		//wideTab added to the top to accept tabs coming in from the top.
		if(top==true){
			translate([(w/2)-(3/8*w),0,h]){
				wideTab(w=3/4*w);
			}
		}
	}
}

module bottomSide(w=bottomWidth(),d=bottomDepth(),h=bottomHeight()){
	union(){
		cube([w,d,h]);
		//There are 12 tabs, 3 per side times 4 sides.  
		//It is all symetrical, thus I know there is more elegant code to do this, but I don't yet know it.
		//Top side tabs
		translate([(1/5*w)-(1/2*tabWidth()),0,h]){
			rotate([0,0,0]){
				tab();
			}
		}
		translate([(2/5*w)-(1/2*tabWidth()),0,h]){
			rotate([0,0,0]){
				tab();
			}
		}
		translate([(3/5*w)-(1/2*tabWidth()),0,h]){
			rotate([0,0,0]){
				tab();
			}
		}
		translate([(4/5*w)-(1/2*tabWidth()),0,h]){
			rotate([0,0,0]){
				tab();
			}
		}
		//Bottom side tabs
		translate([(1/5*w)-(1/2*tabWidth()),woodThickness(),0]){
			rotate([180,0,0]){
				tab();
			}
		}
		translate([(2/5*w)-(1/2*tabWidth()),woodThickness(),0]){
			rotate([180,0,0]){
				tab();
			}
		}
		translate([(3/5*w)-(1/2*tabWidth()),woodThickness(),0]){
			rotate([180,0,0]){
				tab();
			}
		}
		translate([(4/5*w)-(1/2*tabWidth()),woodThickness(),0]){
			rotate([180,0,0]){
				tab();
			}
		}
		//Left tabs
		translate([0,0,(1/4*h)-(1/2*tabWidth())]){
			rotate([0,-90,0]){
				tab();
			}
		}
		translate([0,0,(2/4*h)-(1/2*tabWidth())]){
			rotate([0,-90,0]){
				tab();
			}
		}
		translate([0,0,(3/4*h)-(1/2*tabWidth())]){
			rotate([0,-90,0]){
				tab();
			}
		}
		//Bottom tabs
		translate([w,0,(1/4*h)+(1/2*tabWidth())]){
			rotate([0,90,0]){
				tab();
			}
		}
		translate([w,0,(2/4*h)+(1/2*tabWidth())]){
			rotate([0,90,0]){
				tab();
			}
		}
		translate([w,0,(3/4*h)+(1/2*tabWidth())]){
			rotate([0,90,0]){
				tab();
			}
		}
	}
}

module leftSide(w=leftWidth(),d=leftDepth(),h=leftHeight()){
	difference(){
		union(){
			difference(){
				cube([w,d,h]);
				//Top tabSlots
				translate([(1/4*w)-(1/2*tabWidth())+woodThickness(),2*woodThickness(),h-woodThickness()]){
					rotate([90,0,0]){
						tabSlot();
					}
				}
				translate([(2/4*w)-(1/2*tabWidth()),2*woodThickness(),h-woodThickness()]){
					rotate([90,0,0]){
						tabSlot();
					}
				}
				translate([(3/4*w)-(1/2*tabWidth()),2*woodThickness(),h-woodThickness()]){
					rotate([90,0,0]){
						tabSlot();
					}
				}
				//Front tabSlots
				translate([w-woodThickness(),2*woodThickness(),(1/4*w)+(1/2*tabWidth())]){
					rotate([90,90,0]){
						tabSlot();
					}
				}
				translate([w-woodThickness(),2*woodThickness(),(2/4*w)+(1/2*tabWidth())]){
					rotate([90,90,0]){
						tabSlot();
					}
				}
				translate([w-woodThickness(),2*woodThickness(),(3/4*w)+(1/2*tabWidth())]){
					rotate([90,90,0]){
						tabSlot();
					}
				}
				//Back tabSlots
				translate([0,2*woodThickness(),(1/4*w)+(1/2*tabWidth())]){
					rotate([90,90,0]){
						tabSlot();
					}
				}
				translate([0,2*woodThickness(),(2/4*w)+(1/2*tabWidth())]){
					rotate([90,90,0]){
						tabSlot();
					}
				}
				translate([0,2*woodThickness(),(3/4*w)+(1/2*tabWidth())]){
					rotate([90,90,0]){
						tabSlot();
					}
				}
				//Hinge tabSlot
				translate([woodThickness(),2*woodThickness(),h-woodThickness()]){
					rotate([90,0,0]){
						tabSlot();
					}
				}
			}
			//Hinge tab
			translate([-woodThickness(),0,h]){
				rotate([0,0,0]){
					wideTab(w=tabWidth()+4*woodThickness(),h=tabHeight()+woodThickness());
				}
			}
			//Top tab, will lock with topSide.
			translate([(w/2)-(3/8*w),0,h]){
				rotate([0,0,0]){
					wideTab(w=3/4*w);
				}
			}
			//Front and back tabs, will lock with front and backSides.
			translate([0,0,(h/2)-(3/8*h)]){
				rotate([0,-90,0]){
					wideTab(w=7/8*h,rfillet=false);
				}
			}
			translate([w,0,(h/2)+(3/8*h)]){
				rotate([0,90,0]){
					wideTab(w=3/4*h);
				}
			}
			translate([0,0,-footHeight()]){
				rotate([0,0,0]){
					leftFoot();
				}
			}
		}
		//Hinge hole punch.
		translate([tabWidth()/2+woodThickness(),woodThickness()+0.1,h-woodThickness()/2]){
			rotate([90,0,0]){
				hinge();
			}
		}
		//Left cut
		translate([w-8*woodThickness(),-0.1,3/8*h]){
			rotate([0,0,0]){
				leftCut();
			}
		}
	}
}
projection(cut=false){
//	//Translate dimensions are arbitrary, trying to get a good packing factor for creation of a .dxf file.
//	translate([0,(4/3*topHeight()),0]){
//		rotate([90,0,0]){
//			topSide();
//		}
//	}
//	translate([0,0,0]){
//		rotate([90,0,0]){
//			frontSide(top=true);
//		}
//	}
//	translate([7/6*frontWidth(),0,0]){
//		rotate([90,0,0]){
//			frontSide(top=false);
//		}
//	}
//	translate([7/6*frontWidth(),(4/3*topHeight()),0]){
//		rotate([90,0,0]){
//			bottomSide();
//		}
//	}
//	translate([7/3*frontWidth(),0,0]){
//		rotate([90,0,0]){
//			leftSide();
//		}
//	}
//	//Left and Right are identical, this is the right side.
//	translate([7/3*frontWidth(),(4/3*topHeight()),0]){
//		rotate([90,0,0]){
//			leftSide();
//		}
//	}
//	//34 pins
//	for (i = [1:34]){
//	    translate([i*(4/3*pinWidth()),3/2*frontHeight()+woodThickness(),0]){
//	    	rotate([90,0,0]){
//	    		pin();
//	    	}
//	    }
//	}
//}	