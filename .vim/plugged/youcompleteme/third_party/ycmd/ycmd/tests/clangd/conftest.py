# Copyright (C) 2020 ycmd contributors
#
# This file is part of ycmd.
#
# ycmd is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ycmd is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ycmd.  If not, see <http://www.gnu.org/licenses/>.

import os
import pytest
from ycmd.tests.test_utils import ( ClearCompletionsCache,
                                    IgnoreExtraConfOutsideTestsFolder,
                                    IsolatedApp,
                                    SetUpApp,
                                    StopCompleterServer )
from ycmd.completers.cpp import clangd_completer
shared_app = None


@pytest.fixture( scope='module', autouse=True )
def set_up_shared_app():
  global shared_app
  shared_app = SetUpApp()
  yield
  StopCompleterServer( shared_app, 'cpp' )


@pytest.fixture
def app( request ):
  which = request.param[ 0 ]
  assert which == 'isolated' or which == 'shared'
  if which == 'isolated':
    with IsolatedApp( request.param[ 1 ] ) as app:
      clangd_completer.CLANGD_COMMAND = clangd_completer.NOT_CACHED
      yield app
      StopCompleterServer( app, 'cpp' )
  else:
    global shared_app
    ClearCompletionsCache()
    with IgnoreExtraConfOutsideTestsFolder():
      yield shared_app


"""Defines a decorator to be attached to tests of this package. This decorator
passes the shared ycmd application as a parameter."""
SharedYcmd = pytest.mark.parametrize(
    # Name of the fixture/function argument
    'app',
    # Fixture parameters, passed to app() as request.param
    [ ( 'shared', ) ],
    # Non-empty ids makes fixture parameters visible in pytest verbose output
    ids = [ '' ],
    # Execute the fixture, instead of passing parameters directly to the
    # function argument
    indirect = True )


def IsolatedYcmd( custom_options = {} ):
  """Defines a decorator to be attached to tests of this package. This decorator
  passes a unique ycmd application as a parameter. It should be used on tests
  that change the server state in a irreversible way (ex: a semantic subserver
  is stopped or restarted) or expect a clean state (ex: no semantic subserver
  started, no .ycm_extra_conf.py loaded, etc). Use the optional parameter
  |custom_options| to give additional options and/or override the default ones.

  Example usage:

    from ycmd.tests.python import IsolatedYcmd

    @IsolatedYcmd( { 'python_binary_path': '/some/path' } )
    def CustomPythonBinaryPath_test( app ):
      ...
  """
  return pytest.mark.parametrize(
      # Name of the fixture/function argument
      'app',
      # Fixture parameters, passed to app() as request.param
      [ ( 'isolated', custom_options ) ],
      # Non-empty ids makes fixture parameters visible in pytest verbose output
      ids = [ '' ],
      # Execute the fixture, instead of passing parameters directly to the
      # function argument
      indirect = True )


def PathToTestFile( *args ):
  dir_of_current_script = os.path.dirname( os.path.abspath( __file__ ) )
  return os.path.join( dir_of_current_script, 'testdata', *args )
