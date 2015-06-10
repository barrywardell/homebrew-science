class Blasr < Formula
  desc "PacBio long read aligner"
  homepage "https://github.com/PacificBiosciences/blasr"
  # doi "10.1186/1471-2105-13-238"
  # tag "bioinformatics"

  url "https://github.com/PacificBiosciences/blasr/archive/smrtanalysis-2.2.tar.gz"
  sha256 "bef789accf2662aed409b31227e029c61582d5dfe6a289043db4c1b27fd7ab12"

  head "https://github.com/PacificBiosciences/blasr.git"
  revision 1

  bottle do
    cellar :any
    sha256 "cd3242383848697bb8b2cb3e50098f34fbc3a775b0169b91145f053ed316583d" => :mountain_lion
  end

  depends_on "hdf5"

  fails_with :clang do
    build 602
    cause <<-EOS.undent
      error: destructor type 'HDFWriteBuffer<int>' in object
      destruction expression does not match the type
      'BufferedHDFArray<int>' of the object being destroyed
    EOS
  end

  fails_with :gcc do
    build 5666
    cause <<-EOS.undent
      error: invalid conversion
      from 'void (*)(H5::H5Object&, std::string, void*)'
      to 'void (*)(H5::H5Location&, std::string, void*)'
    EOS
  end

  def install
    hdf5 = Formula["hdf5"]
    system "make", "STATIC=",
      "HDF5INCLUDEDIR=#{hdf5.opt_include}",
      "HDF5LIBDIR=#{hdf5.opt_lib}"

    # Fix the error: install: mkdir /usr/local/Cellar/blasr/2.2/bin: exists
    ENV.deparallelize

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/blasr"
  end
end
