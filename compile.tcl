# Create library and map it
vlib work
vmap work work

# Compile packages first
vcom -2008 ./src/packages/CAM_PKG.vhd

# Compile KEY_FILE
vcom -2008 ./src/modules/KEY_FILE/D_FF.vhd
vcom -2008 ./src/modules/KEY_FILE/DECODER.vhd
vcom -2008 ./src/modules/KEY_FILE/COMPARATOR.vhd
vcom -2008 ./src/modules/KEY_FILE/MULTIPLEXER.vhd
vcom -2008 ./src/modules/KEY_FILE/REPLACEMENT_POINTER.vhd
vcom -2008 ./src/modules/KEY_FILE/PRIORITY_ENCODER.vhd
vcom -2008 ./src/modules/KEY_FILE/MATCHING_CIRCUIT.vhd
vcom -2008 ./src/modules/KEY_FILE/KEY_FILE.vhd

# Compile DATA_FILE
vcom -2008 ./src/modules/DATA_FILE/DATA_FILE.vhd

# Compile CAM TOP MODULE
vcom -2008 ./src/modules/CAM/CAM.vhd

# Compile CAM_TB
vcom -2008 ./src/modules/CAM/CAM_TB.vhd