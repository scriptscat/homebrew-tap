class Sctl < Formula
  desc "ScriptCat local control tool: bridge daemon, MCP server and script CLI"
  homepage "https://github.com/scriptscat/sctl"
  url "https://github.com/scriptscat/sctl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ac80344409bc360704fab5dbdce2befdacd380ee2cf58014ab09304aac9a05db"
  license "GPL-3.0-only"
  head "https://github.com/scriptscat/sctl.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/scriptscat/sctl/internal/cli.Version=#{version}
      -X github.com/scriptscat/sctl/internal/cli.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/sctl"

    generate_completions_from_executable(bin/"sctl", "completion")
  end

  test do
    assert_match "sctl #{version}", shell_output("#{bin}/sctl version")
  end
end
