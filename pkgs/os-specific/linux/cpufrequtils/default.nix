{ lib, stdenv, fetchzip, libtool, gettext }:

stdenv.mkDerivation rec {
  pname = "cpufrequtils";
  version = "008";

  src = fetchzip {
    url = "http://ftp.be.debian.org/pub/linux/utils/kernel/cpufreq/cpufrequtils-${version}.tar.gz";
    hash = "sha256-Dy5Ba6JrelkGPAR0f2tuZaDUQPScTE3KaA8jjz8wUq8=";
  };

  patches = [
    # I am not 100% sure that this is ok, but it breaks repeatable builds.
    ./remove-pot-creation-date.patch
  ];

  patchPhase = ''
    sed -e "s@= /usr/bin/@= @g" \
      -e "s@/usr/@$out/@" \
      -i Makefile
  '';

  buildInputs = [ stdenv.cc.libc.linuxHeaders libtool gettext ];

  meta = with lib; {
    description = "Tools to display or change the CPU governor settings";
    homepage = "http://ftp.be.debian.org/pub/linux/utils/kernel/cpufreq/cpufrequtils.html";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cpufreq-set";
  };
}
