//
//  TKContactsMultiPickerController.m
//  TKContactsMultiPicker
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import "TKContactsMultiPickerController.h"
#import "NSString+TKUtilities.h"
#import "UIImage+TKUtilities.h"

@interface TKContactsMultiPickerController(PrivateMethod)

- (IBAction)saveAction:(id)sender;
- (IBAction)dismissAction:(id)sender;

@end

@implementation TKContactsMultiPickerController
@synthesize tableView = _tableView;
@synthesize tkdelegate = _tkdelegate;
@synthesize savedSearchTerm = _savedSearchTerm;
@synthesize savedScopeButtonIndex = _savedScopeButtonIndex;
@synthesize searchWasActive = _searchWasActive;
@synthesize searchBar = _searchBar;

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   // if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_SYSNAVBAR]) {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedCount = 0;
        _listContent = [NSMutableArray new];
        _filteredListContent = [NSMutableArray new];

    }
    return self;
}

-(id)init
{
    self = [self initWithNibName:@"TKContactsMultiPickerController" bundle:nil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark -
#pragma mark initer
-(void)addBackItem
{
    UIImage *backImg ;
    backImg = [UIImage imageNamed:NavBarCloseIcon];
    
    CGSize imgSize = backImg.size;
    CGRect rect = CGRectZero;
    rect.size = imgSize;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setImage:backImg forState:UIControlStateNormal];
    

    [btn addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)addRightInviteItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    [rightItem setTintColor:colorWithUtfStr("#e0a82e")];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

-(void)setNavTitle:(NSString*)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 30)];
    label.text = title;
    label.textColor =  colorWithUtfStr(NavBarTitleColor);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT_NORMAL_21;
    label.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = label;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.view setBackgroundColor:colorWithUtfStr(CommonViewBGColor)];
    
    [self.navigationController setNavigationBarHidden:FALSE];
    if (IOS_VERSION >= 7.0) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NavBarBgWithStatusBar_IOS7] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NavBarBg_IOS7] forBarMetrics:UIBarMetricsDefault];
    }

    
    [self setNavTitle:@"邀请好友"];
    [self addBackItem];
    [self addRightInviteItem];

	self.searchDisplayController.searchResultsTableView.scrollEnabled = YES;
	self.searchDisplayController.searchBar.showsCancelButton = NO;
    self.searchBar.showsCancelButton = FALSE;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    self.tableView.tintColor = colorWithUtfStr(SortListC_ButtonTextColor);
    //self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = FALSE;
 //   [self.searchBar setBackgroundImage:[UIImage imageNamed:NavBarBgWithStatusBar_IOS7] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setText:_savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    
    // Create addressbook data model
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    
    ABAddressBookRef addressBooks;
    if (IOS_VERSION >= 6.0)
    {
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        addressBooks = ABAddressBookCreate();
#pragma clang diagnostic pop
    }

    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    

    for (NSInteger i = 0; i < nPeople; i++)
    {
        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        
        if (abFullName) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if (abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }

        addressBook.name = SafeString(nameString);
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        addressBook.rowSelected = NO;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString *telStr = (__bridge NSString*)value;
                        addressBook.tel = [telStr telephoneWithReformat];
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        [addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    CFRelease(allPeople);
    CFRelease(addressBooks);
    
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (TKAddressBook *addressBook in addressBookTemp) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(name)];
        addressBook.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (TKAddressBook *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [_listContent addObject:sortedSection];
    }
    


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return nil;
//    } else {
//        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
//                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
//    }
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return 0;
//    } else {
//        if (title == UITableViewIndexSearch) {
//            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
//            return -1;
//        } else {
//            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
//        }
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //tableView.backgroundColor = [UIColor clearColor];
    
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
	} else {
        return [_listContent count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    return [[_listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredListContent count];
    } else {
        return [[_listContent objectAtIndex:section] count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *v= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    v.backgroundColor = colorWithUtfStr(SortListC_ButtonBgColor);
    v.text =  [NSString stringWithFormat:@"  %@",[self tableView:self.tableView titleForHeaderInSection:section]];
    v.textColor = colorWithUtfStr(SortListC_ButtonTextColor);
    v.font = FONT_NORMAL_13;
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCustomCellID];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	TKAddressBook *addressBook = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
        addressBook = (TKAddressBook *)[_filteredListContent objectAtIndex:indexPath.row];
	else
        addressBook = (TKAddressBook *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([[addressBook.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.textLabel.text = addressBook.name;
    } else {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:cell.textLabel.font.pointSize];
        cell.textLabel.text = @"No Name";
    }
	cell.detailTextLabel.text = addressBook.tel;
    cell.detailTextLabel.font = FONT_NORMAL_13;
    cell.detailTextLabel.textColor = colorWithUtfStr(SortListC_ButtonTextColor);
    cell.textLabel.font = FONT_NORMAL_13;
    cell.textLabel.textColor = colorWithUtfStr(SortListC_ButtonTextColor);
    
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(30.0, 0.0, 13, 13)];
	[button setBackgroundImage:[UIImage imageNamed:@"uncheckBox" for:@"TKContactPicker.bundle" ] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"checkBox" for:@"TKContactPicker.bundle" ] forState:UIControlStateSelected];
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [button setSelected:addressBook.rowSelected];
    
	cell.accessoryView = button;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		[self tableView:self.searchDisplayController.searchResultsTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
		[self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else {
		[self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
    
    [self.navigationController.navigationBar.topItem.rightBarButtonItem setEnabled:(_selectedCount > 0)];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	TKAddressBook *addressBook = nil;
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
		addressBook = (TKAddressBook*)[_filteredListContent objectAtIndex:indexPath.row];
	else
        addressBook = (TKAddressBook*)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    BOOL checked = !addressBook.rowSelected;
    addressBook.rowSelected = checked;
    
    // Enabled rightButtonItem
    if (checked) _selectedCount++;
    else _selectedCount--;
    [self.navigationController.navigationBar.topItem.rightBarButtonItem setEnabled:(_selectedCount > 0 ? YES : NO)];
    
    UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    [button setSelected:checked];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	
    
	if (indexPath != nil)
	{
		[self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
    if (self.searchDisplayController.active) {
        BOOL selected = ((UIButton*)sender).selected;
        [((UIButton*)sender) setSelected:!selected];

    }
}

#pragma mark -
#pragma mark Save action

- (IBAction)saveAction:(id)sender
{
	NSMutableArray *objects = [NSMutableArray new];
    for (NSArray *section in _listContent) {
        for (TKAddressBook *addressBook in section)
        {
            if (addressBook.rowSelected)
                [objects addObject:addressBook];
        }
    }
    
    if ([self.tkdelegate respondsToSelector:@selector(contactsMultiPickerController:didFinishPickingDataWithInfo:)])
        [self.tkdelegate contactsMultiPickerController:self didFinishPickingDataWithInfo:objects];
    
}

- (IBAction)dismissAction:(id)sender
{
    if ([self.tkdelegate respondsToSelector:@selector(contactsMultiPickerControllerDidCancel:)])
        [self.tkdelegate contactsMultiPickerControllerDidCancel:self];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{

//	[self.searchDisplayController.searchBar setShowsCancelButton:NO];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    //	[self.searchDisplayController setActive:NO animated:YES];
//	[self.tableView reloadData];
}


#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[_filteredListContent removeAllObjects];
    for (NSArray *section in _listContent) {
        for (TKAddressBook *addressBook in section)
        {
            NSComparisonResult result = [addressBook.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [_filteredListContent addObject:addressBook];
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}
//- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
//{
//    NSLog(@"didShowSearchResultsTableView");
//    controller.searchResultsTableView.backgroundColor = [UIColor redColor];
//    CGRect rect = tableView.frame;
//    rect.origin.y += 64;
//    tableView.frame = rect;
//    tableView.tableHeaderView = Nil;
//
//
//}
#pragma mark -
#pragma mark Memory management

@end