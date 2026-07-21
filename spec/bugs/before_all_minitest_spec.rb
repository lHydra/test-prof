# frozen_string_literal: true

# https://github.com/test-prof/test-prof/issues/342
describe "before_all + minitest 6", type: :integration do
  specify "works" do
    output = run_minitest(
      "before_all_minitest_six",
      chdir: File.join(__dir__, "fixtures")
    )

    expect(output).to include("0 failures")
    expect(output).to include("before_all ran 1 time(s)")
    expect(output).not_to include("before_all ran 2 time(s)")
    expect(output).not_to include("before_all ran 3 time(s)")
  end
end
