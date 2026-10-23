class Sctl < Formula
  desc "ScriptCat local control tool: bridge daemon, MCP server and script CLI"
  homepage "https://github.com/scriptscat/sctl"
  url "https://github.com/scriptscat/sctl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ac80344409bc360704fab5dbdce2befdacd380ee2cf58014ab09304aac9a05db"
  license "GPL-3.0-only"
  head "https://github.com/scriptscat/sctl.git", branch: "main"

  depends_on "go" => :build

  # 源码包里没有 Node 构建产物：下载同版本发布的扩展 zip，编译前放进内嵌目录，sctl browsers install 才有扩展可写。
  resource "browser-extension" do
    url "https://github.com/scriptscat/sctl/releases/download/v0.2.0/sctl-browser-extension-0.2.0.zip"
    sha256 "3b4b351f927ff089b71759cd640cf6e52a3229548979ceda1481558f7b3b6770"
  end

  def install
    resource("browser-extension").stage do
      (buildpath/"internal/pkg/browserext/dist").install Dir["*"]
    end

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
