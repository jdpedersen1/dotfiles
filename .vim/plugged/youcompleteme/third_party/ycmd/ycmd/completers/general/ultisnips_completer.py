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

from ycmd.completers.general_completer import GeneralCompleter
from ycmd import responses


class UltiSnipsCompleter( GeneralCompleter ):
  """
  General completer that provides UltiSnips snippet names in completions.
  """

  def __init__( self, user_options ):
    super().__init__( user_options )
    self._candidates = None
    self._filtered_candidates = None


  def ShouldUseNow( self, request_data ):
    return self.QueryLengthAboveMinThreshold( request_data )


  def ComputeCandidates( self, request_data ):
    if not self.ShouldUseNow( request_data ):
      return []
    return self.FilterAndSortCandidates(
      self._candidates, request_data[ 'query' ] )


  def OnBufferVisit( self, request_data ):
    raw_candidates = request_data.get( 'ultisnips_snippets', [] )
    self._candidates = [
      responses.BuildCompletionData( snip[ 'trigger' ],
                                     '<snip> ' + snip[ 'description' ] )
      for snip in raw_candidates ]
