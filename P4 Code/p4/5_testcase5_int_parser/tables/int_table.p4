

table add_telemetry_t {
    key = {
        hdr.int_meta.instruction_mask_0003 : exact;
    }
    actions = {
        int_set_header_0003_i3;
        NoAction;
    }
    default_action = NoAction();
    size = 2;
    const entries = {
        0 : int_set_header_0003_i3(); //Should be a 3 (or another value), not a 0. This is because traffic tester
    }
}