// Import 'rkn_stp.stp' file which is converted from faces to a solid. Note that the built in CAD kernel cannot pass on any
// surfaces or lines only Volumes. Hence why the conversion from surface to volume is needed and the surfaces cannot be 
// formend into a Volume in OpenCASCADE from geometries passed on from the built-in CAD kernel.
//Merge "rkn_stp.stp";
Merge "rkn_new.stp";

// Change 'Built In' kernel to 'OpenCASCADE'
SetFactory("OpenCASCADE");

// Draw box (Volume) around it the 'rkn_stp.stp' file.
Box(2) = {-500, 3100, -500, 3000, -6500, 1520};

// Subtract Volume 3 form Volumes 1 and 2, and subsequently deleting Volumes 1 and 2.
BooleanDifference{ Volume{2}; }{ Volume{1}; Delete; }
// BooleanDifference{ Volume{3}; }{ Volume{2}; Delete; }
