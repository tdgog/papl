## BlockStatements & Scoping
When a new scope is found, spin up a new Binder with the current Binder's variables 
copied over

```
int a = 5; 
a + 150;

{
  int b = 10;
  b;
  a = a + 1;
}

a;
```


```
{
    1;
}
```