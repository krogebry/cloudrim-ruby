```bash
db.createUser(
    {
        user: "cloudrim",
        pwd: "",
        roles: [
            { role: "readWrite", db: "cloudrim" }
        ],
        mechanisms:[
            "SCRAM-SHA-1"
        ]
    }
)
```

```bash
db.createUser(
    {
        user: "cloudrim",
        pwd: "",
        roles: [
            {"db":"admin", "role":"dbAdminAnyDatabase" }, 
            {"db":"admin", "role":"readWriteAnyDatabase"}, 
            {"db":"admin", "role":"clusterAdmin"}
        ]
    }
)
```
