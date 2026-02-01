$fn = 64;

// ---------------- Parameters ----------------
// Short wall is left
// Peg walls is top

inner_x = 90.0;          // INTERNAL width (inside-to-inside)
inner_y = 55.0;          // INTERNAL depth (inside-to-inside)

base_z  = 3.0;
wall_th = 2.0;
wall_h  = 14.5;

// top wall segment length measured on INSIDE edge
top_seg_inside_len = 31.0;

// pegs (offsets from INSIDE edges)
hole_d = 3.0;               // nominal screw hole dia you referenced
peg_d  = hole_d - 0.5;      // smooth movement
peg_h  = wall_h - 0.2;      // lid clearance

// Peg Shoulders
shoulder_d = hole_d + 3.0;
shoulder_h = 2.7;

// peg location using inside-top-left as reference
peg_x_from_inside_left = 6.2;
peg_y_from_inside_top  = 3.5;
peg_cc_y = 44.6;            // center-to-center spacing in Y

// Vents (lid)
vent_l = 35.0;              // length of each vent slot
vent_w = 1.5;               // width of each vent slot
vent_count = 10;            // number of vents
vent_x_from_inside_left = 14.0;
vent_y_from_inside_top  = 10.0;
vent_pitch = vent_w * 2;    // spacing between vents in Y

// Lid fit (OUTSIDE)
fit_clearance = 0.35;       // PETG outside slip/friction
lid_plate_th  = wall_th;    // same thickness as wall_th
lid_drop_h    = 5.0;        // skirt drop over outside walls

// Render toggles
show_base = false;
show_lid  = true;

// ---------------- Derived ----------------
outer_x = inner_x + 2*wall_th;   // 94.0
outer_y = inner_y + 2*wall_th;   // 59.0

inside_left_x = wall_th;         // 2.0
inside_top_y  = wall_th;         // 2.0

peg_xc = inside_left_x + peg_x_from_inside_left; // 8.2
peg_y1 = inside_top_y  + peg_y_from_inside_top;  // 8.2
peg_y2 = peg_y1 + peg_cc_y;                      // 52.8

// Convert inside segment length to outer segment length (segment starts at left)
top_seg_outer_len = top_seg_inside_len + wall_th; // 33.0

// ---------------- Modules ----------------
module base() {
  union() {
    // Base plate
    cube([outer_x, outer_y, base_z], center=false);

    // Walls on top of base: LEFT full, BOTTOM full, TOP segment
    translate([0, 0, base_z]) {
      // Left wall (full height)
      cube([wall_th, outer_y, wall_h], center=false);

      // Bottom wall (full width)
      translate([0, outer_y - wall_th, 0])
        cube([outer_x, wall_th, wall_h], center=false);

      // Top wall segment (from left)
      cube([top_seg_outer_len, wall_th, wall_h], center=false);
    }

    // Pegs for PCB location (on top of base)
    translate([0, 0, base_z]) {
      for (yy = [peg_y1, peg_y2]) {
        translate([peg_xc, yy, 0]) {
          // Bottom shoulder (board stop)
          cylinder(d=shoulder_d, h=shoulder_h);

          // Upper peg (alignment) on top of shoulder
          translate([0, 0, shoulder_h])
            cylinder(d=peg_d, h=peg_h - shoulder_h - wall_th);
        }
      }
    }
  }
}

module lid_with_vents_outside() {
  // Lid overall footprint (covers outer box with clearance)
  lid_outer_x = outer_x + fit_clearance + 2*wall_th;
  lid_outer_y = outer_y + fit_clearance + 2*wall_th;

  // Underside pocket leaves a skirt of thickness wall_th
  pocket_x = lid_outer_x - 2*wall_th;
  pocket_y = lid_outer_y - 2*wall_th;

  // Vent placement: user offsets are from INSIDE edges, so shift by wall_th
  vent_x0 = wall_th + vent_x_from_inside_left;
  vent_y0 = wall_th + vent_y_from_inside_top;

  difference() {
    // Solid lid volume: plate + skirt drop
    cube([lid_outer_x, lid_outer_y, lid_plate_th + lid_drop_h], center=false);

    // Pocket from underside to form skirt (do not cut into plate)
    translate([wall_th, wall_th, 0])
      cube([pocket_x, pocket_y, lid_drop_h + 0.01], center=false);

    // Vent slots cut through PLATE ONLY (plate starts at Z = lid_drop_h)
    for (i = [0 : vent_count - 1]) {
      translate([vent_x0, vent_y0 + i*vent_pitch, lid_drop_h])
        cube([vent_l, vent_w, lid_plate_th + 0.05], center=false);
    }
  }
}

// ---------------- Model ----------------
if (show_base)
  base();

if (show_lid)
  translate([outer_x + 15, 0, 0])
    lid_with_vents_outside();
