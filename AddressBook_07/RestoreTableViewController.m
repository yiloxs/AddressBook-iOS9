//
//  RestoreTableViewController.m
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/5/26.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "RestoreTableViewController.h"
#import "BackupViewController.h"
#import "GetFile.h"
@interface RestoreTableViewController ()

@end

@implementation RestoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDirectoryEnumerator *myDirectoryEnumerator;
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:[[NSBundle mainBundle] bundlePath]];
    
    NSString *docPath;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docPath = [paths objectAtIndex:0];   //得到文件的路径
    NSLog(@"%@", docPath);
    filePathArray = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    localFileManager=[[NSFileManager alloc] init];  //用于获取文件列表
    
    filePathArray =(NSMutableArray *)[GetFile getFilenamelistOfType:@"vcf" fromDirPath:docPath];
    [self.tableView registerNib:[UINib nibWithNibName:@"RestoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"restoreCell"];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (filePathArray)
    {
        return filePathArray.count;
    }
    else
    {
    return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restoreCell" forIndexPath:indexPath];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@",filePathArray[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:[[NSBundle mainBundle] bundlePath]];
    
    NSString *docPath;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docPath = [paths objectAtIndex:0];   //得到文件的路径
    NSString *data=[filePathArray[indexPath.row] copy];
    NSString *cachePath =[NSString stringWithFormat:@"%@/%@",docPath,data];
    NSLog(@"%@",cachePath);
    self.documentController =
    [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:cachePath]];
    self.documentController.delegate = self;
    [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller

       willBeginSendingToApplication:(NSString *)application

{
    
    
}


-(void)documentInteractionController:(UIDocumentInteractionController *)controller

          didEndSendingToApplication:(NSString *)application

{
    
    
    
}


-(void)documentInteractionControllerDidDismissOpenInMenu:

(UIDocumentInteractionController *)controller

{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
