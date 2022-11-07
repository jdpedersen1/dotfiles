// Copyright (C) 2011-2018 ycmd contributors
//
// This file is part of ycmd.
//
// ycmd is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// ycmd is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with ycmd.  If not, see <http://www.gnu.org/licenses/>.

#include "IdentifierCompleter.h"

#include "Candidate.h"
#include "IdentifierUtils.h"
#include "Result.h"
#include "Utils.h"

namespace YouCompleteMe {


IdentifierCompleter::IdentifierCompleter(
  std::vector< std::string > candidates ) {
  identifier_database_.AddIdentifiers( std::move( candidates ), "", "" );
}


IdentifierCompleter::IdentifierCompleter(
  std::vector< std::string >&& candidates,
  std::string&& filetype,
  std::string&& filepath ) {
  identifier_database_.AddIdentifiers( std::move( candidates ),
                                       std::move( filetype ),
                                       std::move( filepath ) );
}


void IdentifierCompleter::AddIdentifiersToDatabase(
  std::vector< std::string > new_candidates,
  std::string& filetype,
  std::string& filepath ) {
  identifier_database_.AddIdentifiers( std::move( new_candidates ),
                                       std::move( filetype ),
                                       std::move( filepath ) );
}


void IdentifierCompleter::ClearForFileAndAddIdentifiersToDatabase(
  std::vector< std::string > new_candidates,
  std::string& filetype,
  std::string& filepath ) {
  identifier_database_.ClearCandidatesStoredForFile( std::string( filetype ),
                                                     std::string( filepath ) );
  AddIdentifiersToDatabase( std::move( new_candidates ),
                            filetype,
                            filepath );
}


void IdentifierCompleter::AddIdentifiersToDatabaseFromTagFiles(
  std::vector< std::string >& absolute_paths_to_tag_files ) {
  for( auto&& path : absolute_paths_to_tag_files ) {
    identifier_database_.AddIdentifiers(
      ExtractIdentifiersFromTagsFile( std::move( path ) ) );
  }
}


std::vector< std::string > IdentifierCompleter::CandidatesForQuery(
  std::string&& query,
  const size_t max_candidates ) const {
  return CandidatesForQueryAndType( std::move( query ), "", max_candidates );
}


std::vector< std::string > IdentifierCompleter::CandidatesForQueryAndType(
  std::string query,
  const std::string &filetype,
  const size_t max_candidates ) const {

  std::vector< Result > results =
    identifier_database_.ResultsForQueryAndType( std::move( query ),
                                                 filetype,
                                                 max_candidates );

  std::vector< std::string > candidates;
  candidates.reserve( results.size() );

  for ( const Result & result : results ) {
    candidates.emplace_back( result.Text() );
  }

  return candidates;
}


} // namespace YouCompleteMe
