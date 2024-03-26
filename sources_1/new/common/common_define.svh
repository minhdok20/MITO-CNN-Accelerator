// ------------------------------------------------------------------------------------------------------
// ----------------                    COMMON DEFINES                   ---------------------------------
// ------------------------------------------------------------------------------------------------------

// --- PARAMETERS --- 
// ------------------------------------------------------------------------------------------------------                                   
// Register width 
parameter   REGISTER_WIDTH      = 32;                                   // Register width from memory
parameter   INSTRUCTION_WIDTH   = 32;                                   // Register width from memory

// Input buffer
parameter   INPUT_IFM_REG       = 3;                                    // Number of IFM registers 
parameter   INPUT_WGT_REG       = 3;                                    // Number of WGT registers
parameter   INPUT_BIAS_REG      = 1;                                    // NUmber of BIAS registers
parameter   IFM_DATA_WIDTH      = 8;                                    // Each input feature map width 
parameter   WGT_DATA_WIDTH      = 8;                                    // Each weight input width
parameter   BIAS_DATA_WIDTH     = 32;                                   // Bias input width 

// Output 
parameter   OUTPUT_OFM_WIDTH    = 8;                                    // Output OFM width

// PE Array
parameter   PARTIAL_WIDTH       = 16;                                   // PE partial product width
parameter   PE_OUTPUT_WIDTH     = 32;                                   // PE output width
parameter   PE_ARR_SIZE         = 3*3;                                  // PE array size

// Max pooling
parameter   POOL_SIZE           = 2*2;                                  // Max pooling size

// Mode layer
parameter   FULLY_CONVOL        = 1'b0; 
parameter   POOLING             = 1'b1;

// Decode the order in which registers are loaded in fully-convol mode
parameter   IFM                 = 2'b01;
parameter   WGT                 = 2'b10;
parameter   BIAS                = 2'b11;

// Shift mode (in fully-convol mode) 
parameter   ALL                 = 3'b111;
parameter   RIGHT               = 3'b001;
parameter   LEFT                = 3'b010;
parameter   DOWN                = 3'b101;
// ------------------------------------------------------------------------------------------------------