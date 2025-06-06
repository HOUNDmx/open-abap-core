CLASS ltcl_deserialize DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS structure_integer FOR TESTING RAISING cx_static_check.
    METHODS structure_string FOR TESTING RAISING cx_static_check.
    METHODS structure_nested FOR TESTING RAISING cx_static_check.
    METHODS basic_array FOR TESTING RAISING cx_static_check.
    METHODS parse_abap_true FOR TESTING RAISING cx_static_check.
    METHODS parse_abap_true_flag FOR TESTING RAISING cx_static_check.
    METHODS parse_abap_false FOR TESTING RAISING cx_static_check.
    METHODS camel_case FOR TESTING RAISING cx_static_check.
    METHODS short_timestamp FOR TESTING RAISING cx_static_check.
    METHODS long_timestamp FOR TESTING RAISING cx_static_check.
    METHODS via_jsonx FOR TESTING RAISING cx_static_check.
    METHODS empty_reference FOR TESTING RAISING cx_static_check.
    METHODS empty_reference2 FOR TESTING RAISING cx_static_check.
    METHODS basic_reference FOR TESTING RAISING cx_static_check.
    METHODS deserialize_to_ref FOR TESTING RAISING cx_static_check.
    METHODS deserialize_to_ref_nested FOR TESTING RAISING cx_static_check.
    METHODS deserialize_to_esc FOR TESTING RAISING cx_static_check.
    METHODS deserialize_to_ref_bool FOR TESTING RAISING cx_static_check.
    METHODS deserialize_str FOR TESTING RAISING cx_static_check.
    METHODS deserialize_int FOR TESTING RAISING cx_static_check.
    METHODS deserialize_empty_date FOR TESTING RAISING cx_static_check.
    METHODS deserialize_empty_time FOR TESTING RAISING cx_static_check.
    METHODS deserialize_date1 FOR TESTING RAISING cx_static_check.
    METHODS deserialize_time1 FOR TESTING RAISING cx_static_check.
    METHODS deserialize_time2 FOR TESTING RAISING cx_static_check.
    METHODS deserialize_array_ref FOR TESTING RAISING cx_static_check.
    METHODS more_array FOR TESTING RAISING cx_static_check.
    METHODS deserialize_float_to_ref FOR TESTING RAISING cx_static_check.
    METHODS deserialize_packed_empty FOR TESTING RAISING cx_static_check.
    METHODS refs_something FOR TESTING RAISING cx_static_check.
    METHODS raw_to_string FOR TESTING RAISING cx_static_check.
    METHODS string_to_raw FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_deserialize IMPLEMENTATION.

  METHOD string_to_raw.
    DATA generic_string TYPE string VALUE 'TESTING GENERIC STRING TO RAW'.
    cl_abap_unit_assert=>assert_equals(
      act = /ui2/cl_json=>string_to_raw( generic_string )
      exp = '54455354494E472047454E4552494320535452494E4720544F20524157' ).
  ENDMETHOD.

  METHOD raw_to_string.
    DATA generic_string TYPE xstring VALUE '54455354494E472047454E4552494320535452494E4720544F20524157'.
    cl_abap_unit_assert=>assert_equals(
      act = /ui2/cl_json=>raw_to_string( generic_string )
      exp = 'TESTING GENERIC STRING TO RAW' ).
  ENDMETHOD.

  METHOD deserialize_date1.
    DATA: BEGIN OF ls_data,
            date TYPE d,
          END OF ls_data.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{"date": "2023-11-11"}'
      CHANGING
        data = ls_data ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-date
      exp = '20231111' ).
  ENDMETHOD.

  METHOD deserialize_time1.
    DATA: BEGIN OF ls_data,
        time TYPE t,
      END OF ls_data.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{"time": "11:22:33"}'
      CHANGING
        data = ls_data ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-time
      exp = '112233' ).
  ENDMETHOD.

  METHOD deserialize_time2.
    DATA: BEGIN OF ls_data,
        time TYPE t,
      END OF ls_data.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{"time": "112233"}'
      CHANGING
        data = ls_data ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-time
      exp = '112233' ).
  ENDMETHOD.

  METHOD deserialize_empty_date.

    DATA: BEGIN OF ls_data,
            date TYPE d,
          END OF ls_data.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{}'
      CHANGING
        data = ls_data ).

    cl_abap_unit_assert=>assert_initial( ls_data-date ).

  ENDMETHOD.

  METHOD deserialize_empty_time.

    DATA: BEGIN OF ls_data,
            time TYPE t,
          END OF ls_data.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{}'
      CHANGING
        data = ls_data ).

    cl_abap_unit_assert=>assert_initial( ls_data-time ).

  ENDMETHOD.


  METHOD parse_abap_true.
    DATA: BEGIN OF stru,
            foo TYPE abap_bool,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": true}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = lv_json
      CHANGING
        data        = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = abap_true ).
  ENDMETHOD.

  METHOD parse_abap_true_flag.
    DATA: BEGIN OF stru,
            foo TYPE flag,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": true}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = lv_json
      CHANGING
        data        = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = abap_true ).
  ENDMETHOD.

  METHOD parse_abap_false.
    DATA: BEGIN OF stru,
            foo TYPE abap_bool,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": false}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = lv_json
      CHANGING
        data        = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = abap_false ).
  ENDMETHOD.

  METHOD camel_case.
    DATA: BEGIN OF stru,
            foo_bar TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"fooBar": 2}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = lv_json
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING
        data        = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo_bar
      exp = 2 ).
  ENDMETHOD.

  METHOD structure_integer.
    DATA: BEGIN OF stru,
            foo TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": 2}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = 2 ).
  ENDMETHOD.

  METHOD structure_string.
    DATA: BEGIN OF stru,
            foo TYPE string,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": "hello world"}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = 'hello world' ).
  ENDMETHOD.

  METHOD structure_nested.
    DATA: BEGIN OF stru,
            BEGIN OF sub,
              bar TYPE i,
            END OF sub,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"sub": {"bar": 2}}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-sub-bar
      exp = 2 ).
  ENDMETHOD.

  METHOD basic_array.
    DATA: BEGIN OF stru,
            foo TYPE STANDARD TABLE OF i WITH DEFAULT KEY,
          END OF stru.
    DATA lv_int TYPE i.
    DATA lv_json TYPE string.
    lv_json = '{"foo": [5, 7]}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( stru-foo )
      exp = 2 ).
    READ TABLE stru-foo INDEX 2 INTO lv_int.
    ASSERT sy-subrc = 0.
    cl_abap_unit_assert=>assert_equals(
      act = lv_int
      exp = 7 ).
  ENDMETHOD.

  METHOD short_timestamp.
    DATA: BEGIN OF stru,
            ts TYPE timestamp,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"ts": "2023-03-09T21:02:59Z"}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = |{ stru-ts TIMESTAMP = ISO }|
      exp = |2023-03-09T21:02:59| ).
  ENDMETHOD.

  METHOD long_timestamp.
    DATA: BEGIN OF stru,
            ts TYPE timestampl,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"ts": "2023-03-09T21:02:59.930Z"}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_char_cp(
      act = |{ stru-ts TIMESTAMP = ISO }|
      exp = |2023-03-09T21:02:59,9*| ).
  ENDMETHOD.

  METHOD via_jsonx.
    DATA: BEGIN OF stru,
            foo TYPE i,
          END OF stru.
    DATA lv_jsonx TYPE xstring.
    lv_jsonx = '7B22666F6F223A20327D'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        jsonx = lv_jsonx
      CHANGING
        data  = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = 2 ).
  ENDMETHOD.

  METHOD empty_reference.
    DATA ref TYPE REF TO data.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json         = ''
        assoc_arrays = abap_true
      CHANGING
        data         = ref ).
    cl_abap_unit_assert=>assert_initial( ref ).
  ENDMETHOD.

  METHOD empty_reference2.
    DATA ref TYPE REF TO data.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json         = '2'
        assoc_arrays = abap_true
      CHANGING
        data         = ref ).
    cl_abap_unit_assert=>assert_initial( ref ).
  ENDMETHOD.

  METHOD basic_reference.
    TYPES: BEGIN OF ty,
             field TYPE i,
           END OF ty.
    DATA ref TYPE REF TO ty.
    CREATE DATA ref.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json         = '{"field":2}'
        assoc_arrays = abap_true
      CHANGING
        data         = ref ).
    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = ref->field ).
  ENDMETHOD.

  METHOD deserialize_to_ref.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"oSystem":2}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'OSYSTEM' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.
    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = 2 ).
  ENDMETHOD.

  METHOD deserialize_to_ref_nested.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"oSystem":{"ID":"ABC"}}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'OSYSTEM' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'ID' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.
    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = 'ABC' ).
  ENDMETHOD.

  METHOD deserialize_to_esc.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"oUpdate":{"MS_ERROR-CLASSNAME":"hello"}}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'OUPDATE' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.

    ASSIGN COMPONENT 'MS_ERROR_CLASSNAME' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.

    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = 'hello' ).
  ENDMETHOD.

  METHOD deserialize_to_ref_bool.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"fieldname":true}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'FIELDNAME' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.

    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = abap_true ).
  ENDMETHOD.

  METHOD deserialize_str.
    DATA ref TYPE REF TO data.
    DATA lv_type TYPE c LENGTH 1.
    FIELD-SYMBOLS <fs> TYPE any.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{"foo":"600"}'
      CHANGING
        data = ref ).
    ASSIGN ref->('FOO->*') TO <fs>.
    DESCRIBE FIELD <fs> TYPE lv_type.
    cl_abap_unit_assert=>assert_equals(
      act = lv_type
      exp = 'g' ).
  ENDMETHOD.

  METHOD deserialize_int.
    DATA ref TYPE REF TO data.
    DATA lv_type TYPE c LENGTH 1.
    FIELD-SYMBOLS <fs> TYPE any.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{"foo":600}'
      CHANGING
        data = ref ).
    ASSIGN ref->('FOO->*') TO <fs>.
    DESCRIBE FIELD <fs> TYPE lv_type.
    cl_abap_unit_assert=>assert_equals(
      act = lv_type
      exp = 'I' ).
  ENDMETHOD.

  METHOD deserialize_array_ref.

    DATA ref TYPE REF TO data.
    DATA lv_type TYPE c LENGTH 1.
    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs> TYPE any.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{"T_TAB": [{"TITLE": "Peter1"},{"TITLE": "Peter2"}]}'
      CHANGING
        data = ref ).

    ASSIGN ref->('T_TAB->*') TO <tab>.
    ASSERT sy-subrc = 0.

    READ TABLE <tab> INDEX 1 ASSIGNING <fs>.
    ASSERT sy-subrc = 0.

    ASSIGN <fs>->* TO <fs>.
    ASSIGN COMPONENT 'TITLE' OF STRUCTURE <fs> TO <fs>.
    ASSERT sy-subrc = 0.

    ASSIGN <fs>->* TO <fs>.
    cl_abap_unit_assert=>assert_equals(
      act = <fs>
      exp = 'Peter1' ).

  ENDMETHOD.

  METHOD more_array.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        selected TYPE abap_bool,
      END OF ty_row.

    TYPES ty_t_tab TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.

    DATA lt_tab2 TYPE ty_t_tab.
    DATA row LIKE LINE OF lt_tab2.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '[{"TITLE":"Test","VALUE":"this is a description","SELECTED":true}]'
      CHANGING
        data = lt_tab2 ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_tab2 )
      exp = 1 ).

    READ TABLE lt_tab2 INTO row INDEX 1.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = row-title
      exp = 'Test' ).

  ENDMETHOD.

  METHOD deserialize_float_to_ref.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"foo":-0.3333}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'FOO' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.
    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = '-0.3333' ).
  ENDMETHOD.

  METHOD deserialize_packed_empty.

    DATA: BEGIN OF ls_data,
            foo TYPE p LENGTH 5,
          END OF ls_data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = ls_data ).

    cl_abap_unit_assert=>assert_initial( ls_data-foo ).

  ENDMETHOD.

  METHOD refs_something.

    DATA lv_json TYPE string.
    DATA lr_data TYPE REF TO data.

    FIELD-SYMBOLS <any> TYPE any.
    FIELD-SYMBOLS <table> TYPE ANY TABLE.


    lv_json = `{"oScroll": []}`.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_data ).

    cl_abap_unit_assert=>assert_not_initial( lr_data ).
    ASSIGN lr_data->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'OSCROLL' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <table>.
    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = lines( <table> ) ).

  ENDMETHOD.

ENDCLASS.

*****************************************************************************************

CLASS ltcl_serialize DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS structure_integer FOR TESTING RAISING cx_static_check.
    METHODS structure_integer_negative FOR TESTING RAISING cx_static_check.
    METHODS structure_string FOR TESTING RAISING cx_static_check.
    METHODS structure_two_fields FOR TESTING RAISING cx_static_check.
    METHODS basic_array FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestamp_iso FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestamp_iso_empty FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestampl_iso_empty FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestampl_iso FOR TESTING RAISING cx_static_check.
    METHODS camel_case FOR TESTING RAISING cx_static_check.
    METHODS character10 FOR TESTING RAISING cx_static_check.
    METHODS character10_value FOR TESTING RAISING cx_static_check.
    METHODS character10_space FOR TESTING RAISING cx_static_check.
    METHODS string_spaces FOR TESTING RAISING cx_static_check.
    METHODS bool_false FOR TESTING RAISING cx_static_check.
    METHODS bool_true FOR TESTING RAISING cx_static_check.
    METHODS empty_reference FOR TESTING RAISING cx_static_check.
    METHODS basic_ref FOR TESTING RAISING cx_static_check.
    METHODS compress_structure1 FOR TESTING RAISING cx_static_check.
    METHODS compress_structure2 FOR TESTING RAISING cx_static_check.
    METHODS compress_structure3 FOR TESTING RAISING cx_static_check.
    METHODS packed FOR TESTING RAISING cx_static_check.
    METHODS packed_negative FOR TESTING RAISING cx_static_check.
    METHODS escape_quote FOR TESTING RAISING cx_static_check.
    METHODS escape_newline FOR TESTING RAISING cx_static_check.
    METHODS date_field FOR TESTING RAISING cx_static_check.
    METHODS time_field FOR TESTING RAISING cx_static_check.
    METHODS numc_field FOR TESTING RAISING cx_static_check.
    METHODS numc_field2 FOR TESTING RAISING cx_static_check.
    METHODS serialize_empty_xstring FOR TESTING RAISING cx_static_check.
    METHODS serialize_xstring FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_serialize IMPLEMENTATION.

  METHOD serialize_timestampl_iso.
    DATA: BEGIN OF foo,
            ts TYPE timestampl,
          END OF foo.
    DATA lv_json TYPE string.
    GET TIME STAMP FIELD foo-ts.
    lv_json = /ui2/cl_json=>serialize(
      data          = foo
      ts_as_iso8601 = abap_true ).
    cl_abap_unit_assert=>assert_text_matches(
      text    = lv_json
      pattern = '\{"TS":"\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\.\d\d\d\d\d\d\dZ"\}' ).
  ENDMETHOD.

  METHOD serialize_empty_xstring.
    DATA: BEGIN OF is_metadata,
            foo TYPE xstring,
          END OF is_metadata.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( is_metadata ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":""}' ).
  ENDMETHOD.

  METHOD serialize_xstring.
    DATA: BEGIN OF is_metadata,
            foo TYPE xstring,
          END OF is_metadata.
    DATA lv_json TYPE string.
    is_metadata-foo = 'AA'.
    lv_json = /ui2/cl_json=>serialize( is_metadata ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":"qg=="}' ).
  ENDMETHOD.

  METHOD bool_false.
    DATA: BEGIN OF ls_data,
        foo_bar TYPE abap_bool,
      END OF ls_data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":false}' ).
  ENDMETHOD.

  METHOD bool_true.
    DATA: BEGIN OF ls_data,
        foo_bar TYPE abap_bool,
      END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo_bar = abap_true.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":true}' ).
  ENDMETHOD.

  METHOD character10.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE c LENGTH 10,
          END OF ls_data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":""}' ).
  ENDMETHOD.

  METHOD character10_value.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE c LENGTH 10,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo_bar = 'hello'.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":"hello"}' ).
  ENDMETHOD.

  METHOD character10_space.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE c LENGTH 10,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo_bar = ' hello'.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":" hello"}' ).
  ENDMETHOD.

  METHOD string_spaces.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE string,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo_bar = | |.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":" "}' ).
  ENDMETHOD.

  METHOD camel_case.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE i,
          END OF ls_data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize(
      data        = ls_data
      pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"fooBar":0}' ).
  ENDMETHOD.

  METHOD serialize_timestamp_iso.
    DATA: BEGIN OF foo,
            ts TYPE timestamp,
          END OF foo.
    DATA lv_json TYPE string.
    GET TIME STAMP FIELD foo-ts.
    lv_json = /ui2/cl_json=>serialize(
      data          = foo
      ts_as_iso8601 = abap_true ).
    cl_abap_unit_assert=>assert_text_matches(
      text    = lv_json
      pattern = '\{"TS":"\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.0000000Z"\}' ).
  ENDMETHOD.

  METHOD serialize_timestamp_iso_empty.
    DATA: BEGIN OF foo,
            ts TYPE timestamp,
          END OF foo.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize(
      data          = foo
      ts_as_iso8601 = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act    = lv_json
      exp = '{"TS":""}' ).
  ENDMETHOD.

  METHOD serialize_timestampl_iso_empty.
    DATA: BEGIN OF foo,
            ts TYPE timestampl,
          END OF foo.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize(
      data          = foo
      ts_as_iso8601 = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act    = lv_json
      exp = '{"TS":""}' ).
  ENDMETHOD.

  METHOD basic_array.
    DATA tab TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA lv_json TYPE string.
    APPEND 1 TO tab.
    APPEND 2 TO tab.
    lv_json = /ui2/cl_json=>serialize( tab ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '[1,2]' ).
  ENDMETHOD.

  METHOD structure_integer.
    DATA: BEGIN OF stru,
            foo TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    stru-foo = 2.
    lv_json = /ui2/cl_json=>serialize( stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":2}' ).
  ENDMETHOD.

  METHOD structure_integer_negative.
    DATA: BEGIN OF stru,
            foo TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    stru-foo = -2.
    lv_json = /ui2/cl_json=>serialize( stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":-2}' ).
  ENDMETHOD.

  METHOD structure_two_fields.
    DATA: BEGIN OF stru,
            foo TYPE i,
            bar TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":0,"BAR":0}' ).
  ENDMETHOD.

  METHOD structure_string.
    DATA: BEGIN OF stru,
            foo TYPE string,
          END OF stru.
    DATA lv_json TYPE string.
    stru-foo = 'hello'.
    lv_json = /ui2/cl_json=>serialize( stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":"hello"}' ).
  ENDMETHOD.

  METHOD empty_reference.
    DATA ref TYPE REF TO data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( ref ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = 'null' ).
  ENDMETHOD.

  METHOD basic_ref.
    TYPES: BEGIN OF ty,
             field TYPE i,
           END OF ty.
    DATA ref TYPE REF TO ty.
    DATA lv_json TYPE string.
    CREATE DATA ref.
    lv_json = /ui2/cl_json=>serialize( ref ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FIELD":0}' ).
  ENDMETHOD.

  METHOD compress_structure1.
    DATA: BEGIN OF ls_data,
        foo TYPE i,
        bar TYPE i,
      END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo = 1.
    lv_json = /ui2/cl_json=>serialize(
      data     = ls_data
      compress = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":1}' ).
  ENDMETHOD.

  METHOD compress_structure2.
    DATA: BEGIN OF ls_data,
            foo TYPE i,
            bar TYPE i,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-bar = 1.
    lv_json = /ui2/cl_json=>serialize(
      data     = ls_data
      compress = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"BAR":1}' ).
  ENDMETHOD.

  METHOD compress_structure3.
    DATA: BEGIN OF ls_data,
            foo TYPE i,
            bar TYPE i,
          END OF ls_data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize(
      data     = ls_data
      compress = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{}' ).
  ENDMETHOD.

  METHOD packed.
    DATA: BEGIN OF ls_data,
            foo TYPE p LENGTH 10 DECIMALS 3,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo = 2.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":2.000}' ).
  ENDMETHOD.

  METHOD packed_negative.
    DATA: BEGIN OF ls_data,
            foo TYPE p LENGTH 10 DECIMALS 3,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo = -2.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":-2.000}' ).
  ENDMETHOD.

  METHOD escape_quote.
    DATA: BEGIN OF ls_data,
            foo TYPE string,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo = |"|.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":"\""}' ).
  ENDMETHOD.

  METHOD escape_newline.
    DATA: BEGIN OF ls_data,
            foo TYPE string,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo = |\n|.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":"\n"}' ).
  ENDMETHOD.

  METHOD date_field.
    DATA lv_json TYPE string.
    DATA: BEGIN OF ls_message,
            dats TYPE d,
          END OF ls_message.
    ls_message-dats = '20230526'.
    lv_json = /ui2/cl_json=>serialize( ls_message ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"DATS":"2023-05-26"}' ).
  ENDMETHOD.

  METHOD time_field.
    DATA lv_json TYPE string.
    DATA: BEGIN OF ls_message,
            tims TYPE t,
          END OF ls_message.
    ls_message-tims = '112233'.
    lv_json = /ui2/cl_json=>serialize( ls_message ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"TIMS":"11:22:33"}' ).
  ENDMETHOD.

  METHOD numc_field.

    TYPES: BEGIN OF ty_output,
             period TYPE n LENGTH 3,
             fixed  TYPE string,
           END OF ty_output.
    DATA lt_output TYPE STANDARD TABLE OF ty_output WITH DEFAULT KEY.
    DATA lv_json TYPE string.

    APPEND INITIAL LINE TO lt_output.
    lv_json = /ui2/cl_json=>serialize( lt_output ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '[{"PERIOD":0,"FIXED":""}]' ).

  ENDMETHOD.

  METHOD numc_field2.

    DATA period  TYPE n LENGTH 3.
    DATA lv_json TYPE string.

    period = 2.
    lv_json = /ui2/cl_json=>serialize( period ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '2' ).

  ENDMETHOD.

ENDCLASS.