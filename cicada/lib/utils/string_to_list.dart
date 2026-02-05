List<String> stringToListSemicolon(String oldString) =>
    oldString.split(';').map((String e) => e.trim()).toList();
