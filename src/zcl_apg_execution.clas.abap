class ZCL_APG_EXECUTION definition
  public
  final
  create public .

public section.

  types:
    TT_BAPIRET2 TYPE STANDARD TABLE OF BAPIRET2 WITH EMPTY KEY .

  class-methods EXECUTE_GATE
    importing
      !I_POINT_ID type ZAPG_POINT_ID
      !I_CONTEXT type ref to ZIF_APG_CONTEXT
    changing
      !CO_MESSAGE_CONTAINER type TT_BAPIRET2
    raising
      ZCX_APG_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_APG_EXECUTION IMPLEMENTATION.


  METHOD execute_gate.

    DATA(lt_handlers) = zcl_apg_factory=>get_active_handlers_for_gate( i_point_id = i_point_id
                                                                       i_context  = i_context ).

    LOOP AT lt_handlers INTO DATA(lo_handler).

      TRY.
          lo_handler->execute( EXPORTING i_context            = i_context
                               CHANGING  co_message_container = co_message_container ).
        CATCH zcx_apg_error INTO DATA(lx_apg).
          DATA(lv_exception_message) = lx_apg->get_text( ).
          co_message_container = VALUE #( BASE co_message_container ( type       = 'E'
                                                                      id         = ''
                                                                      number     = ''
                                                                      message    = CONV #( lv_exception_message )
                                                                      message_v1 = CONV #( lv_exception_message ) ) ).
        CATCH cx_root INTO DATA(lx_root).
          lv_exception_message = lx_root->get_text( ).
          co_message_container = VALUE #( BASE co_message_container ( type       = 'E'
                                                                      id         = ''
                                                                      number     = ''
                                                                      message    = CONV #( lv_exception_message )
                                                                      message_v1 = CONV #( lv_exception_message ) ) ).
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
