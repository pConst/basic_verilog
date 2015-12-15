# This constructs a DLL plug in for Modelsim from float_vpi.cpp
# It contains a few floating point helper functions.

# The Modelim PLI interface library - modify Modelsim path if necessary
if [ -f d:/Modeltech_6.1d/win32/mtipli.lib ]
then
  cp D:/Modeltech_6.1d/win32/mtipli.lib .
else
  echo "Please modify Modelsim binary path in shell script"
  exit
fi

# Compile C helper file
cl -c -ID:. float_vpi.cpp

# Link with MTI lib to form plug in DLL
link -dll -export:vlog_startup_routines float_vpi.obj mtipli.lib -out:float_vpi.dll 

if [ -f float_vpi.dll ] 
then
   echo "float_vpi.dll built successfully"
else
   echo "Error building DLL"
fi
