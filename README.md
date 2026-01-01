🚧 Status: Under Development

# ABAP Point Gate

The ABAP Point Gate is a structured approach to managing ABAP exit points by isolating custom code

## License
This project is licensed under the [MIT License](https://github.com/greltel/ABAP-Point-Gate/blob/main/LICENSE).

## Contributors-Developers
The repository was created by [George Drakos](https://www.linkedin.com/in/george-drakos/).

## Motivation for Creating the Repository

ABAP Point Gate to provide a standardized “gate” around ABAP exit points/enhancements, so custom logic stays isolated from the SAP core instead of being scattered across standard objects. This helps keep the system clean, maintainable, and upgrade-friendly, while offering a consistent way to implement enhancements that aligns with Clean Core / ABAP Cloud readiness practices and encourages quality through automated checks (e.g. abaplint) and unit testing.

## Usage Examples

### 1. Prepare the Context
Wrap your business data (e.g., structures, objects, variables) into the ZCL_APG_CONTEXT object.

```abap
DATA(lo_context) = NEW zcl_apg_context( ).

" Store the data with a unique name (e.g., 'BKPF')
lo_context->set_data( i_name  = 'BKPF' 
                      i_value = lr_bkpf ).
```

### 2.Execute the Gate
Call the factory method EXECUTE_GATE with the specific Point ID.

```abap
TRY.
    " 2. Call the Gate
    " The Point ID 'SAMPLE_SAVE_BEFORE' must be configured in table ZAPG_POINT
    zcl_apg_execution=>execute_gate(
      EXPORTING
        i_point_id           = 'SAMPLE_SAVE_BEFORE'
        i_context            = lo_context
      CHANGING
        co_message_container = lt_msg_cont ).
  CATCH zcx_apg_error INTO DATA(lx_apg).
    " Handle framework errors (e.g., configuration missing, instantiation failed)
    MESSAGE lx_apg TYPE 'E'.
ENDTRY.
```

### 3.Handle Results
Check for returned messages or retrieve modified data from the context.

```abap
TRY.    
    " A. Check for validation messages returned by handlers
    IF line_exists( lt_msg_cont[ type = 'E' ] ).
       " Handle errors (e.g., abort save, show log)
    ENDIF.

    " B. Retrieve potentially modified data
    " If a handler modified the data, we can get the updated reference back
    lo_context->get_data( 
      EXPORTING 
        i_name  = 'BKPF' 
      IMPORTING 
        e_value = DATA(lr_changed_bkpf) ).
CATCH zcx_apg_error INTO DATA(lx_apg).
    " Handle framework errors (e.g., configuration missing, instantiation failed)
    MESSAGE lx_apg TYPE 'E'.
ENDTRY.
```

## Design Goals/Features

* Install via [ABAPGit](http://abapgit.org)
* ABAP Cloud/Clean Core compatibility.Passed SCI check variant S4HANA_READINESS_2023 and ABAP_CLOUD_READINESS
* Unit Tested
* [ABAPLint](https://github.com/apps/abaplint) checked
