# Document for Database NoteApp

Built and maintained by our [Collaborators](#collaborators)

```
All data access must to use BUS class
```
:hammer_and_wrench:
:heavy_check_mark:
:warning:
:exclamation:
## Lớp NoteBUS: 
###### Status: :hammer_and_wrench:
**Mô tả**: NoteBUS cung cấp các phương thức để thực hiện các thao tác với table note

**1. Khởi tạo**

*Tham số:* Không

*Trả về:* Object 

Cú pháp:` var notebus = new NoteBUS();`

- thêm record vào bảng "notes" : notebus.addNote(Notes note);
- update record : notebus.updateNote(Notes note);
- xóa 1 record : notebus.deleteNoteById(String note_id);
- xóa tất cả record : notebus.deleteAll();
- trả về 1 record với note_id có sẵn : notebus.getNoteById(String note_id);
- trả về tất cả record với filter : notebus.getNotes(String Querry);
- trả về tất cả record : notebus.getNotes();
Lớp TagBUS:
- Khởi tạo: var tagbus = new TagBUS();
- thêm record vào bảng "notes" : tagbus.addTag(Tag tag);
- update record : tagbus.updateTag(Tag tag);
- xóa 1 record : tagbus.deleteTagById(String tag_id);
- xóa tất cả record : tagbus.deleteAll();
- trả về 1 record với note_id có sẵn : tagbus.getTagById(String tag_id);
- trả về tất cả record với filter : tagbus.getTags(String Querry);
- trả về tất cả record : tagbus.getTags();
Lớp ThumbnailBUS:
- Khởi tạo: var thumbnail_bus = new ThumbnailBUS();
- thêm record vào bảng "thumbnails" : thumbnail_bus.addThumbnail(ThumbnailNote note);
- update record : thumbnail_bus.updateThumbnail(ThumbnailNote note);
- xóa 1 record : thumbnail_bus.deleteThumbnailById(String note_id);
- xóa tất cả record : thumbnail_bus.deleteAll();
- trả về 1 record với note_id có sẵn : thumbnail_bus.getThumbnailById(String note_id);
- trả về tất cả record với filter : thumbnail_bus.getThumbnails(String Query);
- trả về tất cả record : thumbnail_bus.getThumbnails();
