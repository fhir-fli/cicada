List<String> stringToListSemicolon(String oldString) =>
    oldString.split(';').map((e) => e.trim()).toList();
