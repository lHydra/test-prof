# frozen_string_literal: true

describe "RSpecDissect with cross-thread let", type: :integration do
  specify do
    output = run_rspec(
      "rspec_dissect_cross_thread",
      chdir: File.join(__dir__, "fixtures"),
      env: {"RD_PROF" => "1"}
    )

    expect(output).to include("1 example, 0 failures")
    expect(output).to include("RSpecDissect report")
  end
end
