CLASS zcl_apg_injector DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS get_handler
      IMPORTING i_classname      TYPE ABAP_CLASSNAME
      RETURNING VALUE(r_handler) TYPE REF TO zif_apg_handler
      RAISING   zcx_apg_error.

    CLASS-METHODS get_toggle
      IMPORTING i_classname     TYPE ABAP_CLASSNAME
      RETURNING VALUE(r_toggle) TYPE REF TO zif_apg_activation_toggle
      RAISING   zcx_apg_error.

    CLASS-METHODS inject_instance
      IMPORTING i_classname TYPE ABAP_CLASSNAME
                i_instance  TYPE REF TO object.

    CLASS-METHODS clear.

    CLASS-METHODS inject_configuration
      IMPORTING i_point_id TYPE zapg_point_id
                i_config   TYPE ANY TABLE.

    CLASS-METHODS get_configuration
      IMPORTING i_point_id TYPE zapg_point_id
      EXPORTING e_config   TYPE ANY TABLE.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_mock_config,
             point_id TYPE zapg_point_id,
             data     TYPE REF TO data,
           END OF ty_mock_config.

    TYPES ty_mock_configs TYPE HASHED TABLE OF ty_mock_config WITH UNIQUE KEY point_id.

    CLASS-DATA mt_mock_configs TYPE ty_mock_configs.

    TYPES: BEGIN OF ty_mock,
             classname TYPE abap_classname,
             instance  TYPE REF TO object,
           END OF ty_mock.

    CLASS-DATA mt_mocks TYPE HASHED TABLE OF ty_mock WITH UNIQUE KEY classname.

    CLASS-METHODS get_instance
      IMPORTING i_classname       TYPE ABAP_CLASSNAME
      RETURNING VALUE(r_instance) TYPE REF TO object.

ENDCLASS.


CLASS zcl_apg_injector IMPLEMENTATION.
  METHOD clear.
    CLEAR mt_mocks.
  ENDMETHOD.

  METHOD get_configuration.
    CLEAR e_config.

    ASSIGN mt_mock_configs[ point_id = i_point_id ] TO FIELD-SYMBOL(<ls_mock>).
    IF syst-subrc IS INITIAL.

      ASSIGN <ls_mock>-data->* TO FIELD-SYMBOL(<lt_data>).

      TRY.
          e_config = <lt_data>.
        CATCH cx_sy_move_cast_error.
          CLEAR e_config.
      ENDTRY.

    ENDIF.
  ENDMETHOD.

  METHOD get_handler.
    " Check for Mock existence
    DATA(lo_mock) = get_instance( i_classname ).
    IF lo_mock IS BOUND.
      r_handler = CAST #( lo_mock ).
      RETURN.
    ENDIF.

    " Creation of Production Code
    TRY.
        CREATE OBJECT r_handler TYPE (i_classname).
      CATCH cx_sy_create_object_error.
        RAISE EXCEPTION NEW zcx_apg_error( ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_instance.
    r_instance = VALUE #( mt_mocks[ classname = i_classname ]-instance OPTIONAL ).
  ENDMETHOD.

  METHOD get_toggle.
    DATA(lo_mock) = get_instance( i_classname ).
    IF lo_mock IS BOUND.
      r_toggle = CAST #( lo_mock ).
      RETURN.
    ENDIF.

    TRY.
        CREATE OBJECT r_toggle TYPE (i_classname).
      CATCH cx_sy_create_object_error.
        RAISE EXCEPTION NEW zcx_apg_error( ).
    ENDTRY.
  ENDMETHOD.

  METHOD inject_configuration.
    DATA lr_data TYPE REF TO data.

    " Deep Copy
    CREATE DATA lr_data LIKE i_config.
    ASSIGN lr_data->* TO FIELD-SYMBOL(<lt_target>).
    <lt_target> = i_config.

    DELETE mt_mock_configs WHERE point_id = i_point_id.
    INSERT VALUE #( point_id = i_point_id
                    data     = lr_data ) INTO TABLE mt_mock_configs.
  ENDMETHOD.

  METHOD inject_instance.
    DELETE mt_mocks WHERE classname = i_classname.
    INSERT VALUE #( classname = i_classname
                    instance  = i_instance ) INTO TABLE mt_mocks.
  ENDMETHOD.
ENDCLASS.
