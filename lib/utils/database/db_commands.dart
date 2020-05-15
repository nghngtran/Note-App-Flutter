const String CREATE_TABLE_NOTE = "CREATE TABLE notes("
    "note_id TEXT PRIMARY KEY, "
    "title TEXT, "
    "tag_id TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_TAG = "CREATE TABLE IF NOT EXISTS tags("
    "tag_id TEXT PRIMARY KEY, "
    "title TEXT, "
    "color TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_NOTE_ITEM = "CREATE TABLE noteItems("
    "noteItem_id TEXT PRIMARY KEY, "
    "note_id TEXT, "
    "content TEXT, "
    "type TEXT, "
    "textColor TEXT, "
    "bgColor TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const String CREATE_TABLE_RELATIVE = "CREATE TABLE relatives("
    "note_id TEXT, "
    "tag_id TEXT"
    ")";
const String DROP_TABLE_TAG = "DROP TABLE IF EXISTS tags";
const String DROP_TABLE_NOTE = "DROP TABLE IF EXISTS notes";
const String DROP_TABLE_NOTE_ITEM = "DROP TABLE IF EXISTS noteItems";
const String DROP_TABLE_RELATIVE = "DROP TABLE IF EXISTS relatives";

final String SELECT_TAG_RELATIVES_JOIN_TAGS =
    "SELECT *FROM relatives re INNER JOIN tags tg ON re.tag_id=tg.tag_id WHERE re.note_id=?";
final String SELECT_NOTE_ITEMS=
    "SELECT *FROM noteItems WHERE note_id=?";
