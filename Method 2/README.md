# Guide to converting a surface to a volume file to perform Boolian operations in GMSH

This guide explains how a surface CAD file can be converted to a volume file

## Installation of Inventor

Inventor can be used for free on an educational license. Since you have a University of Bristol email address you are able to get an educational license. Inventor can be downloaded from here [Autodesk Student Access to Education Downloads](https://www.autodesk.com/education/edu-software/overview#INVPROSA). Select **Student**, which will bring you to a form which you will need to fill in (Note that you will need to use your `bristol.ac.uk` email address. Once that is done click **submit**.

Autodesk will then send you an email to verify your acount to your `birstol.ac.uk` email address. Click on the **Complete Account Setup** button on the email. This will transfer you back to the Autodesk website. Once a password is set it will lead you the page where you can download and install Inventor.

## Convert file

I have only managed to get the following to work with `.stp` files. Since `.stl` files are mesh files this is not possible. I also have tried `.igs` files, and while it can be exported as a `.stp` file, I found that **GMSH** does not like the file for some reason. But I think with a bit of tinkering around this should also be possible. The following explains how to convert a **surface** `.stp` file to a **volume** `.stp` file.

1. Open Inventor
  
2. Open file by clicking **File** → **Open** → **Import CAD Files** 

    ![Import](figures/2025-01-23-09-27-53-image.png)
  
3. Select `.stp` file (if you can't see the file, then select the **Files of type** as *STEP Files*) and click **Open**.    

    ![Open](figures/2025-01-23-11-43-00-image.png) 
  
4. Now you will be presented with this window

    ![Selection](figures/Screenshot 2025-01-23 151120.png)

  Important here is that
  a) you select **Convert Model** in the **Import Type**,
  b) and only select **Surfaces** in **Object Filters** and
  c) that you select the **Individual** option in the **Part Options** → **Surfaces**
  Once that is done click **OK**

5. This has now imported all surfaces individually which looks something like this

    ![](figures/Screenshot 2025-01-23 151444.png)
  
6. Focusing on the object tree on the left hand side as shown in the figure below

    ![](figures/Screenshot 2025-01-23 151623.png)

  We can see all the individual surfaces. The reason why we need to import them all individually is to check whether there are any surfaces causing singularity issues later in GMSH. For this reason we need to delete all surfaces which are within the body or are adjacent to another surface.

7. This can be done by hovering over the individual surfaces on the object tree on the left hand side which means surfaces `Surf_ABBOQFRLXS, WingGeom, 0`, `Surf_ABBOQFRLXS, WingGeom, 0:1`, `Surf_ABBOQFRLXS, WingGeom, 1` and `Surf_ABBOQFRLXS, WingGeom, 1:1` must be deleted. This can be done by selecting the surface on the object tree and hit the `delete` key on the keyboard or by right clicking onto the surface and select `Delete`. Once this is done the wing should look like this:

    ![](figures/Screenshot 2025-01-23 152610.png)

> [!NOTE]
> This step can be skipped if there are no such surfaces identified in the model which is possible.

8. Now the surfaces can be converted into a solid. This can be done by selecting all surfaces in the object tree (`shift` + `click`) and by selecting the `Stitch` tool which is in **3D model** → **Surface**.

    ![](figures/Screenshot 2025-01-23 153106.png)

    which opens this window

    ![](figures/Screenshot 2025-01-23 153300.png)

    Click `Apply` and then `Done`.

    If it was successful, the object tree should now show the stitched surface like this

    ![](figures/Screenshot 2025-01-23 154555.png)
  
9. This can now be exported as `.stp` file. Click **File** → **Export** → **CAD Format**

    ![](figures/2025-01-23-12-53-50-image.png) 

  and then you are presented with this window

    ![](figures/2025-01-23-12-55-04-image.png) 

  Click **Save**

## GMSH

Attached to this repository is a the working `.geo` GMSH file as shown below:

```
Merge "rkn_new.stp";

// Change 'Built In' kernel to 'OpenCASCADE'
SetFactory("OpenCASCADE");

// Draw box (Volume) around it the 'rkn_stp.stp' file.
Box(3) = {-500, 3100, -100, 3000, -6500, 220};

// Subtract Volume 3 form Volumes 1 and 2, and subsequently deleting Volumes 1 and 2.
BooleanDifference{ Volume{3}; }{ Volume{1}; Delete; }
BooleanDifference{ Volume{3}; }{ Volume{2}; Delete; }
```
The way this script works as follows:

```
Merge "rkn_new.stp";
```

This line imports 'rkn_new.stp' file which is converted from faces to a solid. Note that the built in CAD kernel cannot pass on any surfaces or lines only Volumes. Hence why the conversion from surface to volume is needed and the surfaces cannot be formend into a Volume in OpenCASCADE from geometries passed on from the built-in CAD kernel. Hence why we converted the file into a volume file in the previous step.

```
SetFactory("OpenCASCADE");
```

Changes the 'Built In' kernel to 'OpenCASCADE' so that boolian operations can be performed on the imported part.

```
Box(3) = {-500, 3100, -100, 3000, -6500, 220};
```

Draws a box (Volume) around it the 'rkn_new.stp' file.

> [!IMPORTANT]
> Note that this line defines an additional volume. Since we import two volumes from the `rkn_new.stp` file we must denote specify the new box $N_{volumes .stp} + 1$ which is in this case 3. 