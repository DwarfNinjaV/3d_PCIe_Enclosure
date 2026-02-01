# PCIe Adapter Enclosure (OpenSCAD)

This repository contains a **parametric OpenSCAD enclosure** designed to hold a PCIe adapter board using locating pegs and an **external friction-fit vented lid**.

The enclosure is intended for homelab / bench use and was tuned for **PETG** printing.

---

## Hardware Used

- **PCIe Adapter**  
  https://amzn.to/4q9va76

- **PCIe Expansion / Extension Cable**  
  https://amzn.to/4qasJkE

- **Filament (PETG)**  
  https://amzn.to/45GObGP

---

## Design Overview

### Enclosure
- Internal cavity sized directly from PCB dimensions
- External walls grow outward from internal dimensions
- One **short wall segment** used as a physical reference stop
- One **open side** for cable clearance

### PCB Retention
- Two **stepped locating pegs**
  - Large shoulder supports the PCB vertically
  - Smaller upper peg provides alignment only
- Peg diameters are intentionally undersized to allow easy insertion and removal

### Lid
- **Outside-fit lid** (slips over the exterior of the enclosure)
- Friction-fit skirt tuned for PETG
- Continuous skirt for retention
- Vent slots cut through the lid plate only (skirt remains intact)

---

## Coordinate System (IMPORTANT)

This design relies on OpenSCAD’s coordinate system.  
Misinterpreting this will result in mirrored peg placement.
- X axis → left to right
- Y axis → top to bottom
- Z axis → bottom to top

### Physical Meaning in This Model

- **Short wall = LEFT side (X = 0)**
- **Peg reference wall = TOP side (Y = 0)**
- **Open side = BOTTOM (largest Y)**

All PCB peg offsets are measured from:
- **Inside-left edge**
- **Inside-top edge**

If the PCB only fits when flipped 180°, the board orientation is incorrect — the peg geometry itself is correct.

---

## Printing Notes

### Recommended Settings (PETG, 0.6 mm nozzle)
- Layer height: 0.24–0.28 mm  
- Walls: 4–5 perimeters  
- Infill: 25–35%  
- Top/bottom layers: ≥5  
- Supports: none  

### Fit Tuning
- Lid too tight → increase `fit_clearance`
- Lid too loose → decrease `fit_clearance`
- PCB tight on pegs → reduce peg diameter slightly

---

## Exporting Parts

The OpenSCAD file supports exporting the base and lid independently.
## Examples:

Export base only
show_base = true; show_lid = false;

Export lid only
show_base = false; show_lid = true;

```scad
show_base = true;
show_lid  = true;
```
---

## Modification Notes

### Recommended Settings (PETG, 0.6 mm nozzle)
- PCB alignment is tied to the short wall and top wall orientation
* Always reference new features from those same physical datums
- Changing wall orientation without updating peg references will mirror the layout

### License/Use
Use, modify, and print freely.
If you improve the design, pull requests are welcome.

---
