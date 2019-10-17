open Json_storage

let testable_thought = Alcotest.testable (fun _f _a -> ()) (fun _a _b -> false)

let test_suite = [
  "load empty metadata", `Quick, (fun () ->
      let empty_json = "{}" in

      let metadata = Loader.load [(Uuid_unix.create (), empty_json)] in

      Alcotest.(check (Alcotest.option (Alcotest.list testable_thought))) "should be empty" (Some []) metadata
    );
]
