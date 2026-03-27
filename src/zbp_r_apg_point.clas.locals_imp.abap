CLASS lhc_gate DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS validateHandlerClass FOR VALIDATE ON SAVE
      IMPORTING keys FOR Gate~validateHandlerClass.

ENDCLASS.

CLASS lhc_gate IMPLEMENTATION.
  METHOD validateHandlerClass.
    READ ENTITIES OF ZR_APG_Point IN LOCAL MODE
         ENTITY Gate
         FIELDS ( HandlerClass )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_gates).

    LOOP AT lt_gates INTO DATA(ls_gate) WHERE HandlerClass IS NOT INITIAL.

      DATA(lv_not_Exist) = abap_false.
      DATA(lv_not_implement) = abap_false.

      TRY.

          cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = ls_gate-HandlerClass
                                               RECEIVING  p_descr_ref    = DATA(lo_descr)
                                               EXCEPTIONS type_not_found = 1 ).

          IF syst-subrc IS NOT INITIAL.
            lv_not_Exist = abap_true.
          ELSEIF lo_descr->kind = cl_abap_typedescr=>kind_class.

            DATA(lo_class_descr) = CAST cl_abap_classdescr( lo_descr ).

            IF NOT line_exists( lo_class_descr->interfaces[ name = 'ZIF_APG_HANDLER' ] ).
              lv_not_implement = abap_true.
            ENDIF.

          ELSEIF lo_descr->kind <> cl_abap_typedescr=>kind_class.
            lv_not_Exist = abap_true.
          ENDIF.

        CATCH cx_root.
          lv_not_Exist = abap_false.
      ENDTRY.

      IF lv_not_Exist = abap_true OR lv_not_implement = abap_true.

        APPEND VALUE #( %tky = ls_gate-%tky ) TO failed-gate.

        APPEND VALUE #(
            %tky                  = ls_gate-%tky
            %msg                  = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = COND #( WHEN lv_not_Exist = abap_true THEN
                                     |Class { ls_gate-HandlerClass } doesn't exist|
                                   WHEN lv_not_implement = abap_true THEN
                                     |{ ls_gate-HandlerClass } must implement ZIF_APG_HANDLER| ) )
            %element-handlerclass = if_abap_behv=>mk-on ) TO reported-gate.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_point DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR point RESULT result.

ENDCLASS.

CLASS lhc_point IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
