const String CREATE_TABLE_NOTE = "CREATE VIRTUAL TABLE notes("
    "note_id TEXT PRIMARY KEY, "
    "title TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_NOTE_FTS = "CREATE VIRTUAL TABLE notes_fts USING fts4("
    "content='notes', "
    "title"
    ")";
const String CREATE_TABLE_TAG = "CREATE VIRTUAL TABLE IF NOT EXISTS tags("
    "tag_id TEXT PRIMARY KEY, "
    "title TEXT, "
    "color TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_TAG_FTS = "CREATE VIRTUAL TABLE tags_fts USING fts4("
    "content='tags', "
    "title"
    ")";
const String CREATE_TABLE_NOTE_ITEM = "CREATE VIRTUAL TABLE noteItems("
    "noteItem_id TEXT PRIMARY KEY, "
    "note_id TEXT, "
    "content TEXT, "
    "type TEXT, "
    "textColor TEXT, "
    "bgColor TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_NOTE_ITEM_FTS = "CREATE VIRTUAL TABLE noteItems_fts USING fts4("
    "content='noteItems', "
    "content"
    ")";
const String CREATE_TABLE_RELATIVE = "CREATE TABLE relatives("
    "note_id TEXT, "
    "tag_id TEXT"
    ")";
const String DELETE_TAG ="DELETE FROM tags";
const String DELETE_NOTE = "DELETE FROM notes";
const String DELETE_NOTE_ITEM = "DELETE FROM noteItems";
const String DELETE_RELATIVE = "DELETE FROM relatives";

const String DROP_TABLE_TAG = "DROP TABLE IF EXISTS tags";
const String DROP_TABLE_NOTE = "DROP TABLE IF EXISTS notes";
const String DROP_TABLE_NOTE_ITEM = "DROP TABLE IF EXISTS noteItems";
const String DROP_TABLE_RELATIVE = "DROP TABLE IF EXISTS relatives";

final String SELECT_TAG_RELATIVES_JOIN_TAGS =
    "SELECT *FROM relatives re INNER JOIN tags tg ON re.tag_id=tg.tag_id WHERE re.note_id=?";
final String SELECT_NOTE_ITEMS=
    "SELECT *FROM noteItems WHERE note_id=?";
final String SELECT_NOTES_BY_TAGID =
    "SELECT *FROM relatives re INNER JOIN notes no ON re.note_id=no.note_id WHERE re.tag_id=?";
final String FTS_NOTE_ITEM = "SELECT * FROM noteItems WHERE content MATCH ?";
final String FTS_NOTE="SELECT * FROM notes WHERE title MATCH ?";
final String FTS_TAG="SELECT * FROM tags WHERE title MATCH ?";