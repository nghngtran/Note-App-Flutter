# Document for Database NoteApp

Database SQLITE use library [SQFLITE by tekartik](https://github.com/tekartik/sqflite/tree/master/sqflite/doc) at [pub.dev](https://pub.dev/packages/sqflite) or [github](https://github.com/tekartik/sqflite)

Built and maintained by our [Collaborators](#collaborators)

```
All data access operations must be used via the BUS layer
```
:hammer_and_wrench:
:heavy_check_mark:
:warning:
:exclamation:
## Lớp NoteBUS:  
###### Status: :hammer_and_wrench:
**Mô tả**: NoteBUS cung cấp các phương thức để thực hiện các thao tác với table note

**1. Khởi tạo**

- *Tham số:* **`Không`**

- *Trả về:* **`Object`** 

- Cú pháp:` var notebus = new NoteBUS();`

**2. Thêm record vào bảng**

- *Tham số:* **`Note`** Object

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await notebus.addNote(Notes note);`

**3. Update record vào bảng**

- *Tham số:* **`Note`** Object

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await notebus.updateNote(String noteId);`

**4. Xóa 1 record với ID xác định khỏi bảng**

- *Tham số:* **`String`** NoteID

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await notebus.deleteNote(String noteId);`

**5. Xóa tất cả record khỏi bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await notebus.deleteAllNote();`

**6. Lấy 1 Note object từ bảng**

- *Tham số:* **`String`** ID

- *Trả về:* **`Note`** :**object** nếu thành công, **`null`** nếu thất bại

- Cú pháp:` Note note = await notebus.getNoteById(String noteId);`

**7. Lấy tất cả Note object từ bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`List<Note>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<Note> notes = await notebus.getNotes();`

**8. Lấy tất cả Note object với Query String từ bảng**

- *Tham số:* **`String`** Query

- *Trả về:* **`List<Note>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<Note> notes = await notebus.getNotes(String Query);`

## Lớp TagBUS:  
###### Status: :heavy_check_mark:
**Mô tả**: TagBUS cung cấp các phương thức để thực hiện các thao tác với table tag

**1. Khởi tạo**

- *Tham số:* **`Không`**

- *Trả về:* **`Object`** 

- Cú pháp:` var tagbus = new TagBUS();`

**2. Thêm record vào bảng**

- *Tham số:* **`Tag`** object

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await tagbus.addTag(Tag tag);`

**3. Update record vào bảng**

- *Tham số:* **`Tag`** object

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await tagbus.updateTag(Tag tag);`

**4. Xóa 1 record với ID xác định khỏi bảng**

- *Tham số:* **`String`** tagId

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await tagbus.deleteTagById(String tagId);`

**5. Xóa tất cả record khỏi bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await tagbus.deleteAll();`

**6. Lấy 1 Tag object từ bảng**

- *Tham số:* **`String`** ID

- *Trả về:* **`Tag`** :**object** nếu thành công, **`null`** nếu thất bại

- Cú pháp:` Tag tag = await tagbus.getTagById(String tagId);`

**7. Lấy tất cả Tag object từ bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`List<Tag>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<Tag> tags = await tagbus.getTags();`

**8. Lấy tất cả Tag object với Query String từ bảng**

- *Tham số:* **`String`** Query

- *Trả về:* **`List<Tag>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<Tag> tags = await tagbus.getTags(String Query);`

## Lớp ThumbnailBUS:  
###### Status: :heavy_check_mark:
**Mô tả**: ThumbnailBUS cung cấp các phương thức để thực hiện các thao tác với thumbnail của 1 note đã tồn tại

**1. Khởi tạo**

- *Tham số:* **`Không`**

- *Trả về:* **`Object`** 

- Cú pháp:` var thumbnailbus = new ThumbnailBUS();`

**2. Xóa 1 record với ID của note xác định khỏi bảng**

- *Tham số:* **`String`** NoteId

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await thumbnailbus.deleteThumbnailById(String note_id);`

**3. Xóa tất cả record khỏi bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await thumbnailbus.deleteAll();`

**4. Lấy 1 Thumbnail object từ bảng**

- *Tham số:* **`String`** ID

- *Trả về:* **`ThumbnailNote`** :**object** nếu thành công, **`null`** nếu thất bại

- Cú pháp:` ThumbnailNote thumbnail = await thumbnailbus.getTagById(String tagId);`

**5. Lấy tất cả Thumbnail object từ bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`List<ThumbnailNote>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<ThumbnailNote> thumbnails = await thumbnailbus.getThumbnails();;`

**6. Lấy tất cả Thumbnail object với Query String từ bảng**

- *Tham số:* **`String`** Query

- *Trả về:* **`List<ThumbnailNote>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<ThumbnailNote> thumbnails = await thumbnailbus.getTags(String Query);`

**7. Lấy tất cả Thumbnail onject với Keyword bằng kĩ thuật FullTextSearch

*chú thích*: *Chỉ áp dụng cho Title của Note*

- *Tham sốL* **`String`** Keyword

- *Trả về:* **`List<ThumbnailNote>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<ThumbnailNote> thumbnails = await thumbnailbus.getThumbnailsByKeyWord(String Keyword);`

**8. Lấy tất cả Thumbnail onject với Keyword bằng kĩ thuật FullTextSearch

*chú thích*: *áp dụng cho cả Title và Content Text Item của Note*

- *Tham sốL* **`String`** Keyword

- *Trả về:* **`List<ThumbnailNote>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<ThumbnailNote> thumbnails = await thumbnailbus.getThumbnailsByKeyWordAll(String Keyword);`

:heavy_check_mark:
