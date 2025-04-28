CLASS ltcl_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: failed TYPE RESPONSE FOR FAILED ZR_01ACONN_NMT,
          reported TYPE RESPONSE FOR REPORTED ZR_01ACONN_NMT.

    METHODS setup.
    METHODS teardown.
    METHODS test_validate_carrid_mt FOR TESTING RAISING cx_static_check.
    METHODS test_validate_carrid_not_mt FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD setup.
    " Xóa dữ liệu trước mỗi test
    CLEAR: failed, reported.
  ENDMETHOD.

  METHOD teardown.
    " Dọn dẹp dữ liệu sau mỗi test
    CLEAR: failed, reported.
  ENDMETHOD.

  METHOD test_validate_carrid_mt.
    " Trường hợp: carrid = 'MT' -> Phải thất bại và báo lỗi

    " Bước 1: Tạo dữ liệu giả lập cho entity Flight_NMT
    DATA(flight) = VALUE ZR_01ACONN_NMT(
      uuid = '1234567890ABCDEF'
      carrid = 'MT'
    ).

    " Bước 2: Sử dụng EML để thực hiện thao tác MODIFY và COMMIT
    MODIFY ENTITIES OF ZR_01ACONN_NMT IN LOCAL MODE
      ENTITY Flight_NMT
        CREATE SET FIELDS WITH VALUE #( ( %cid = 'CID1' %data = flight ) )
      MAPPED DATA(mapped)
      FAILED failed
      REPORTED reported.

    " Bước 3: COMMIT để kích hoạt logic validate
    COMMIT ENTITIES
      RESPONSE OF ZR_01ACONN_NMT
      FAILED failed
      REPORTED reported.

    " Bước 4: Kiểm tra kết quả
    " Kiểm tra failed-Flight_NMT: phải có 1 bản ghi thất bại
    cl_abap_unit_assert=>assert_equals(
      act  = lines( failed-Flight_NMT )
      exp  = 1
      msg  = 'Validation should fail for carrid = MT'
    ).

    " Kiểm tra reported-Flight_NMT: phải có 1 thông điệp lỗi
    cl_abap_unit_assert=>assert_equals(
      act  = lines( reported-Flight_NMT )
      exp  = 1
      msg  = 'Validation should report an error for carrid = MT'
    ).

    " Kiểm tra nội dung thông điệp lỗi (bỏ kiểm tra severity)
    IF lines( reported-Flight_NMT ) > 0.
      DATA(reported_record) = reported-Flight_NMT[ 1 ].
      cl_abap_unit_assert=>assert_equals(
        act  = reported_record-%msg->if_t100_message~t100key-msgid
        exp  = 'ZMSG_01ACONN_NMT'
        msg  = 'Error message ID should be ZMSG_01ACONN_NMT'
      ).
      cl_abap_unit_assert=>assert_equals(
        act  = reported_record-%msg->if_t100_message~t100key-msgno
        exp  = '102'
        msg  = 'Error message number should be 102'
      ).
    ENDIF.
  ENDMETHOD.

  METHOD test_validate_carrid_not_mt.
    " Trường hợp: carrid ≠ 'MT' -> Không thất bại, không báo lỗi

    " Bước 1: Tạo dữ liệu giả lập cho entity Flight_NMT
    DATA(flight) = VALUE ZR_01ACONN_NMT(
      uuid = '9876543210FEDCBA'
      carrid = 'AA'
    ).

    " Bước 2: Sử dụng EML để thực hiện thao tác MODIFY và COMMIT
    MODIFY ENTITIES OF ZR_01ACONN_NMT IN LOCAL MODE
      ENTITY Flight_NMT
        CREATE SET FIELDS WITH VALUE #( ( %cid = 'CID2' %data = flight ) )
      MAPPED DATA(mapped)
      FAILED failed
      REPORTED reported.

    " Bước 3: COMMIT để kích hoạt logic validate
    COMMIT ENTITIES
      RESPONSE OF ZR_01ACONN_NMT
      FAILED failed
      REPORTED reported.

    " Bước 4: Kiểm tra kết quả
    " Kiểm tra failed-Flight_NMT: phải rỗng
    cl_abap_unit_assert=>assert_equals(
      act  = lines( failed-Flight_NMT )
      exp  = 0
      msg  = 'Validation should not fail for carrid ≠ MT'
    ).

    " Kiểm tra reported-Flight_NMT: phải rỗng
    cl_abap_unit_assert=>assert_equals(
      act  = lines( reported-Flight_NMT )
      exp  = 0
      msg  = 'Validation should not report an error for carrid ≠ MT'
    ).
  ENDMETHOD.
ENDCLASS.
