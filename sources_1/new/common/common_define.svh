// ------------------------------------------------------------------------------------------------------
// ----------------                    COMMON DEFINES                   ---------------------------------
// ------------------------------------------------------------------------------------------------------

// --- PARAMETERS --- 
// ------------------------------------------------------------------------------------------------------                                   
// Register width 
parameter   REGISTER_WIDTH      = 32;                                   // Register width from memory

// Input buffer
parameter   INPUT_IFM_REG       = 3;                                    // Number of IFM registers 
parameter   INPUT_WGT_REG       = 3;                                    // Number of WGT registers
parameter   INPUT_IFM_WIDTH     = 8;                                    // Each input feature map width 
parameter   INPUT_WGT_WIDTH     = 8;                                    // Each weight input width
parameter   INPUT_BIAS_WIDTH    = 32;                                   // Bias input width 

// Output 
parameter   OUTPUT_OFM_WIDTH    = 8;                                    // Output OFM width

// PE Array
parameter   PARTIAL_WIDTH       = IFM_INPUT_WIDTH + WGT_INPUT_WIDTH;    // PE partial product width
parameter   PE_OUTPUT_WIDTH     = 32;                                   // PE output width
parameter   PE_ARR_SIZE         = 3*3;                                  // PE array size

// Max pooling
parameter   POOL_SIZE           = 2*2;                                  // Max pooling size

// Mode layer
parameter   CONVOLUTIONAL       = 2'b01;
parameter   FULLY               = 2'b10;
parameter   POOLING             = 2'b11;
// ------------------------------------------------------------------------------------------------------