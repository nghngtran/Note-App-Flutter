const String CREATE_TABLE_NOTE = "CREATE VIRTUAL TABLE notes USING fts4("
    "note_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
    "title TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_THUMBNAIL_NOTE = "CREATE TABLE thumbnails("
    "note_id INTEGER PRIMARY KEY NOT NULL, "
    "title TEXT, "
    "type TEXT, "
    "content TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_TAG = "CREATE VIRTUAL TABLE tags USING fts4("
    "tag_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
    "title TEXT, "
    "color INTEGER, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    //"UNIQUE (title)"
    ")";
const String CREATE_TABLE_NOTE_ITEM = "CREATE VIRTUAL TABLE noteItems USING fts4("
    "noteItem_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
    "note_id TEXT, "
    "content TEXT, "
    "type TEXT, "
    "note_color INTEGER, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_RELATIVE = "CREATE TABLE relatives("
    "note_id INTEGER, "
    "tag_id INTEGER"
    ")";
const String DELETE_TAG ="DELETE FROM tags";
const String DELETE_NOTE = "DELETE FROM notes";
const String DELETE_NOTE_ITEM = "DELETE FROM noteItems";
const String DELETE_RELATIVE = "DELETE FROM relatives";

const String DROP_TABLE_TAG = "DROP TABLE IF EXISTS tags";
const String DROP_TABLE_NOTE = "DROP TABLE IF EXISTS notes";
const String DROP_TABLE_NOTE_ITEM = "DROP TABLE IF EXISTS noteItems";
const String DROP_TABLE_RELATIVE = "DROP TABLE IF EXISTS relatives";
const String DROP_TABLE_THUMBNAIL = "DROP TABLE IF EXISTS thumbnails";

final String SELECT_TAG_RELATIVES_JOIN_TAGS =
    "SELECT *FROM relatives re INNER JOIN tags tg ON re.tag_id=tg.tag_id WHERE re.note_id=?";
final String SELECT_NOTE_ITEMS=
    "SELECT *FROM noteItems WHERE note_id=?";
final String SELECT_NOTES_BY_TAGID =
    "SELECT *FROM relatives re INNER JOIN notes no ON re.note_id=no.note_id WHERE re.tag_id=?";
final String FTS_NOTE_ITEM = "SELECT * FROM noteItems WHERE content MATCH ?";
final String FTS_NOTE="SELECT * FROM notes WHERE title MATCH ?";
final String FTS_TAG="SELECT * FROM tags WHERE title MATCH ?";
final String COUNT = "SELECT COUNT(*) FROM ?";