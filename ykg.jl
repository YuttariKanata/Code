using PkgTemplates
t = Template(;
                  user="myusername",
                  license="MIT",
                  authors=["Seimei Abe"],
                  dir="./code",
                  julia_version=v"1.0",
                  plugins=[
                      TravisCI(),
                      Codecov(),
                      Coveralls(),
                  ],
              )
