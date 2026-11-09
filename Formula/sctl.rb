class Sctl < Formula
  desc "ScriptCat local control tool: bridge daemon, MCP server and script CLI"
  homepage "https://github.com/scriptscat/sctl"
  url "https://github.com/scriptscat/sctl/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d91439c9394d6599cba514a0be98ddbbabdef9b33c7e050f44c2f6fb7aca949a"
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
