class WelcomeController < ApplicationController

  FILE_NAME = "/tmp/tell-me-your-ip.ips"

  def index
    ip = request.remote_ip
    save_ip(ip)
    render :text => ip
  end

  def show
    render :text => ips.join("<br>")
  end

  private
  def save_ip(ip)
    saved_ips = ips rescue []
    saved_ips.insert(0, ip)
    saved_ips = saved_ips.uniq
    File.open(FILE_NAME, "w"){|f| f.write saved_ips[0..20].join("\n")}
  end

  def ips
    File.open(FILE_NAME).readlines.map(&:strip).compact
  end
end
