# Exit immediately if a command returns a non-zero status.
set -e

test -d "$HOME/.pyenv/bin" && export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

pyenv global ${YCM_PYTHON_VERSION}

# It is quite easy to get the steps to configure Python wrong. Verify that the
# version of Python actually in the PATH and used is the version that was
# requested, and fail the build if we broke the setup.
python_version=$(python -c 'import sys; print( "{}.{}.{}".format( *sys.version_info[:3] ) )')
echo "Checking python version (actual ${python_version} vs expected ${YCM_PYTHON_VERSION})"
test ${python_version} == ${YCM_PYTHON_VERSION}
YCM_TESTRUN=1 python build.py --clang-completer --clang-tidy --valgrind
python run_tests.py --valgrind --skip-build --no-flake8

set +e
