{ stdenv
, buildPythonPackage
, fetchPypi
, curtsies
, greenlet
, mock
, pygments
, requests
, substituteAll
, urwid
, which }:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fec7d97be9912a50d8f5b34ca10d70715c99a33f0cd0b9e4977c1b0f617fa913";
  };

  patches = [ (substituteAll {
    src = ./clipboard-make-which-substitutable.patch;
    which = "${which}/bin/which";
  })];

  propagatedBuildInputs = [ curtsies greenlet pygments requests urwid ];

  postInstall = ''
    substituteInPlace "$out/share/applications/org.bpython-interpreter.bpython.desktop" \
      --replace "Exec=/usr/bin/bpython" "Exec=$out/bin/bpython"
  '';

  checkInputs = [ mock ];

  # tests fail: https://github.com/bpython/bpython/issues/712
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A fancy curses interface to the Python interactive interpreter";
    homepage = "https://bpython-interpreter.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
